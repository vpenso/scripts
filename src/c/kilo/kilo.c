/***** TODO: current line number in status bar, chap 4. *****/

#define _DEFAULT_SOURCE
#define _BSD_SOURCE
#define _GNU_SOURCE

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <termios.h> // general terminal interface
#include <unistd.h>

/*** 
 *
 * Defines
 *
 ***/

#define KILO_VERSION "0.0.1"
#define KILO_TAB_STOP 8

// bitwise-ANDs a character with the value 00011111
#define CTRL_KEY(k) ((k) & 0x1f)

enum editor_key {
        ARROW_LEFT = 1000,
        ARROW_RIGHT,
        ARROW_UP,
        ARROW_DOWN,
        DEL_KEY,
        HOME_KEY,
        END_KEY,
        PAGE_UP,
        PAGE_DOWN
};

/*** 
 *
 * Data 
 *
 ***/

struct termios tflags;

// editor row, store a line of text
typedef struct erow {
        int size;
        int rsize; // size of contents to render
        char *chars;
        // actual representation of the line, curated invisible characters
        char *render;
} erow;

/*
 * global editor state
 */
struct editor_config {
        int cx, cy;      // cursor position in the text buffer character row
        int rx;          // cursor position in the text buffer render row
        int row_offset;  // track the row focused by the cursor
        int col_offset;  // track the column  focused by the cursor
        int screenrows;
        int screencols;
        int numrows;
        erow *row;       // multi line row edit row buffer
        char *filename;
        struct termios tflags;
};
struct editor_config E;



/*
 * Error handling
 */
void die(const char *s) {
        // clear screen
        write(STDOUT_FILENO, "\x1b[2J",4);
        write(STDOUT_FILENO, "\x1b[H", 3);
        // look at the global errno
        // print descriptive error
        perror(s);
        exit(1); // indicates failure
}

/*** 
 *
 * Terminal interface 
 *
 * ***/

/*
 * Disable terminal raw-mode
 * */
void raw_mode_disable() {
        // restore the original terminal configuration
        if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &E.tflags) == -1)
                die("tcsetattr");
}

/*
 * Enable terminal raw-mode
 * */
void raw_mode_enable() {
        
        // read the current terminal configuration
        if (tcgetattr(STDIN_FILENO, &E.tflags) == -1) die("tcgetattr");
        
        // at normal process termination call registered function
        atexit(raw_mode_disable);
        
        // copy the original terminal configuration
        struct termios mtflags = E.tflags;
        
        // configure misc. flags
        //   ECHO   - disable input character echo
        //   ICANON - enable canonical mode
        //   ISIG   - disable program suspend to background C^c C^z
        //   IEXTEN - control character handling
        mtflags.c_lflag &= ~(ECHO | ICANON | ISIG | IEXTEN);

        // configure input flags
        //   IXON   - disable flow control C^s C^q
        //   ICRNL  - translate carriage return to newline on input 
        //   BRKINT - a break condition (i.e. C^c) sends SIGINT
        //   INPCK  - enables parity checking
        //   ISTRIP - stripp 8th bit of each input byte
        mtflags.c_iflag &= ~(IXON | ICRNL | BRKINT | INPCK | ISTRIP);

        // configure output flags
        mtflags.c_oflag &= ~(OPOST); // turn off all output processing

        // configure control mode
        mtflags.c_cflag |= ~(CS8); // sets the character size to 8 bits per byte

        // configure special characters
        mtflags.c_cc[VMIN] = 0; // minimum number of bytes before read() returns
        mtflags.c_cc[VTIME] = 1; // max. time to wait for read() in 100ms

        // use the modified terminal flags to write the new configuration
        if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &mtflags) == -1)
                die("tcsetattr");
}

/*
 * Wait for key press, and return it
 */
int editor_read_key() {
        int nread;
        char c;

        // read 1 byte from the standard input into the variable c
        while ((nread = read(STDIN_FILENO, &c, 1)) != 1)
                if (nread == -1 && errno != EAGAIN) die("read");

        // handle escape sequences 
        if (c == '\x1b') {

                // buffer for the escape sequence
                char seq[3];

                // read two more bytes, otherwise assume ESC key
                if (read(STDIN_FILENO, &seq[0], 1) != 1) return '\x1b';
                if (read(STDIN_FILENO, &seq[1], 1) != 1) return '\x1b';

                if (seq[0] == '[') {

                        if (seq[1] >= '0' && seq[1] <= '9') {

                                // read one more byte, otherwise assume ESC key
                                if(read(STDIN_FILENO, &seq[2], 1) != 1) return '\x1b';
                                
                                if (seq[2] == '~') {
                                        switch (seq[1]) {
                                                case '1': return HOME_KEY;
                                                case '3': return DEL_KEY;
                                                case '4': return END_KEY;
                                                case '5': return PAGE_UP;
                                                case '6': return PAGE_DOWN;
                                                case '7': return HOME_KEY;
                                                case '8': return END_KEY;
                                        }
                                }
                        
                        } else {
                                switch (seq[1]) {
                                        case 'A': return ARROW_UP;
                                        case 'B': return ARROW_DOWN;
                                        case 'C': return ARROW_RIGHT;
                                        case 'D': return ARROW_LEFT;
                                        case 'H': return HOME_KEY;
                                        case 'F': return END_KEY;
                                }
                        }

                } else if (seq[0] == 'O') {
                        switch (seq[1]) {
                                case 'H': return HOME_KEY;
                                case 'F': return END_KEY;
                        }
                }

                // unrecognized escape sequence
                return '\x1b';

        // non escape sequence characters
        } else {
                return c;
        }
}

int get_window_size(int *rows, int *cols) {
        struct winsize ws;
        //  Terminal IOCtl (which itself stands for Input/Output Control) Get WINdow SiZe.)
        if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == -1 || ws.ws_col == 0) {
                return -1;// on failure
        } else {
                // pass values back by setting the int references
                *cols = ws.ws_col;
                *rows = ws.ws_row;
                return 0; // success
        }
}

/*** 
 *
 * Row operations
 *
 ***/

/*
 * Convert the index in character row into the same index in render row
 */
int editor_row_cx_to_rx(erow *row, int cx) {
        int rx = 0;
        int column;
        // iterate in column until the position of the character row index
        for (column = 0; column < cx; column++) {
                // if character in column is a tab
                if (row->chars[column] == '\t') {
                        // move cursor to tab stop
                        rx += (KILO_TAB_STOP - 1) - (rx % KILO_TAB_STOP);
                }
                rx++;
        }
        return rx;
}

/*
 * Render a text line out of the original character string (includes 
 * control characters) into its representation in the text editor
 */
void editor_update_row(erow *row) {
        int tabs = 0;
        int column;

        // iterate character-by-character thru the line
        for (column = 0; column < row->size; column++) {
                // count tabs
                if (row->chars[column] == '\t') tabs++;
        }

        // delete a previously rendered line
        free(row->render);
        // allocate new memory for the line to render
        row->render = malloc(row->size + tabs*(KILO_TAB_STOP - 1) + 1);

        int column_count = 0;
        // iterate character-by-character thru the line
        for(column = 0; column < row->size; column++) {
                // is the current character a tab
                if (row->chars[column] == '\t') {
                        // append spaces until tabstop
                        row->render[column_count++] = ' ';
                        while (column_count % KILO_TAB_STOP != 0)
                                row->render[column_count++] = ' ';
                // non special characters
                } else {
                        // copy character to the render line
                        row->render[column_count++] = row->chars[column];
                }
        }
        // append terminator at the end of line
        row->render[column_count] = '\0';
        // remember to number of columns in line
        row->rsize = column_count;
}

/*
 * Append a new text row to the end of the editor text buffer
 */
void editor_append_row(char *s, size_t len) {
        // allocate space for a new text row
        E.row = realloc(E.row, sizeof(erow) * (E.numrows + 1));
        // number of the last row in the editor text buffer
        int end = E.numrows;
        // remember the length of the new text row
        E.row[end].size = len;
        // allocate memory for the new text row
        E.row[end].chars = malloc(len + 1);
        // copy character the text row to allocated memory 
        memcpy(E.row[end].chars, s, len);
        // append string terminator literal
        E.row[end].chars[len] = '\0';
        // initialize text representation
        E.row[end].rsize = 0 ;
        E.row[end].render = NULL;
        editor_update_row(&E.row[end]);
        // increase counter for the number of text rows in editor buffer
        E.numrows++;
}

/*** 
 *
 * File IO
 *
 ***/

void editor_open(char *filename) {
        // delete previous filename memory
        free(E.filename);
        // remember filename in editor state
        E.filename = strdup(filename);
        FILE *fp = fopen(filename, "r");
        if (!fp) die("editor_open");

        char *line = NULL;
        size_t linecap = 0;
        ssize_t linelen;
        // allocates memory, reads a line-by-line, return length
        while((linelen = getline(&line, &linecap, fp)) != -1 ) {
                // strip off the newline or carriage return at the end of the line
                while (linelen > 0 && (line[linelen - 1] == '\n' || line[linelen - 1] == '\r'))
                        linelen--;
                // append the line to the editor text buffer
                editor_append_row(line, linelen);
        }
        // de-allocate memory
        free(line);
        fclose(fp);
}

/*** 
 *
 * Append Buffer
 *
 ***/

struct abuf {
        char *b; // pointer to memory buffer
        int len; // length of the buffer
};

#define ABUF_INIT {NULL, 0}

/*
 * Append string s to append buffer abuf
 */
void abuf_append(struct abuf *ab, const char *s, int len) {
        // allocate enough memory to hold the new string,
        // size of current string plus size of string to append
        char *new = realloc(ab->b, ab->len + len);
        // realloc changes the size of the memory block pointed to
        
        if(new == NULL) return;

        // append string s after current string
        memcpy(&new[ab->len], s, len);

        // update pointer and length of abuf
        ab->b = new;
        ab->len += len;
}

/*
 * Deallocate dynamic memory used buy the apend buffer
 */
void abuf_free(struct abuf *ab) {
        free(ab->b);
}

/*** 
 *
 * Output
 *
 ***/

/*
 * Check if the cursor moved outside the visible window,
 * and adjust the editor row offset
 */
void editor_scroll() {
        E.rx = 0;
        // if cursor is left of the end of line
        if (E.cy < E.numrows) {
                // move cursor column
                E.rx = editor_row_cx_to_rx(&E.row[E.cy], E.cx);
        }
        // is the cursor above the visible window
        if (E.cy < E.row_offset) 
                E.row_offset = E.cy;
        // is the cursor below the visible window
        if (E.cy >= E.row_offset + E.screenrows) // top of screen + screen height
                E.row_offset = E.cy - E.screenrows + 1;
        if (E.rx < E.col_offset)
                E.col_offset = E.cx;
        if (E.rx >= E.col_offset + E.screencols)
                E.col_offset = E.cx - E.screencols + 1;
}

/*
 * Draw the screen row by row
 */
void editor_draw_rows(struct abuf *ab) {
        int y;
        for (y = 0; y < E.screenrows; y++) {
                int txbuf_row = y + E.row_offset;
                if (txbuf_row >= E.numrows) {
                        // unless text from a file is in the text buffer or the 
                        // screen is to small to show the welcome message
                        if (E.numrows == 0 && y == E.screenrows / 3) {
                                char welcome[80];
                                // interpolate editor version to welcome string
                                int wlen = snprintf(welcome, sizeof(welcome),"Kilo editor -- version %s", KILO_VERSION);
                                // truncate the length if terminal to small
                                if(wlen > E.screencols) wlen = E.screencols;
                                // center the welcome text at screen width divided by 2
                                int padding = (E.screencols - wlen) / 2;
                                // if there is space from the left edge of the screen
                                if (padding) {
                                        abuf_append(ab, "~", 1);
                                        padding--;
                                }
                                // fill space until welcome message
                                while (padding--)
                                        abuf_append(ab, " ", 1);
                                // write welcome message
                                abuf_append(ab, welcome, wlen);
                        } else {
                                // draw a tilde at the beginning of any lines that come
                                // after the end of the file being edited
                                abuf_append(ab, "~", 1);
                        }
                // draw lines from editor text buffer
                } else {
                        // length of the text line in this row
                        int len = E.row[txbuf_row].rsize - E.col_offset;
                        // do not scroll horizontally past the end of line
                        if (len < 0) len = 0;
                        // truncate length to display screen width
                        if (len > E.screencols) len = E.screencols;
                        // append text row to the screen buffer
                        abuf_append(ab, &E.row[txbuf_row].render[E.col_offset], len);
                }

                // erase part of the line to the right of the cursor
                abuf_append(ab, "\x1b[K", 3);
                // no linefeed in last line 
                abuf_append(ab, "\r\n", 2);
        }
}

/*
 * Draw a single line with the status bar
 */
void editor_draw_status_bar(struct abuf *ab) {
        // start invert color
        abuf_append(ab, "\x1b[7m", 4);

        // print filename and number of lines in file
        char status[80];
        // format status line
        int len = snprintf(status, sizeof(status),
                        "%.20s - %d lines",
                        E.filename ? E.filename : "[No Name]", E.numrows);
        // truncate at max. screen width
        if (len > E.screencols) len = E.screencols;
        // append status line to screen buffer
        abuf_append(ab, status, len);
        while (len < E.screencols) {
                abuf_append(ab, " ", 1);
                len++;
        }
        // stop invert color
        abuf_append(ab, "\x1b[m", 3);
}

/*
 * Clear the screen, and print the screen buffer to STDOUT
 */
void editor_refresh_screen() {

        // adjust if cursor moved outside the visible window
        editor_scroll();

        // initialize the screen buffer, (string append buffer)
        struct abuf ab = ABUF_INIT;

        //  \x1b[, (2 byte) escape character [vt100]

        // hide the cursor
        abuf_append(&ab, "\x1b[?25l", 6);
        // position cursor 1:1 (column:row) 
        abuf_append(&ab, "\x1b[H", 3);

        // pass the reference to the screen buffer to the row drawing function
        editor_draw_rows(&ab);
        // after editor text buffer print status line
        editor_draw_status_bar(&ab);

        // move cursor to the position stored in the editor configuration
        char buf[32];
        // correct for terminal indexes
        snprintf(buf, sizeof(buf), "\x1b[%d;%dH", (E.cy - E.row_offset) + 1, (E.rx - E.col_offset) + 1); 
        abuf_append(&ab, buf, strlen(buf));

        // show the cursor
        abuf_append(&ab, "\x1b[?25h", 6);

        // print the screen buffer
        write(STDOUT_FILENO, ab.b, ab.len);
        abuf_free(&ab);
}

/*** 
 *
 * Input 
 *
 * ***/


/*
 * Translate cursor move keys to editor cursor position
 */
void editor_move_cursor(int key) {
        // allowed to be one past the last line of the text
        erow *row = (E.cy >= E.numrows) ? NULL : &E.row[E.cy];
        // prevent the cursor from moving out of the editor text buffer
        switch(key) {
                case ARROW_LEFT:
                        // if cursor is not in the most left column
                        if (E.cx != 0) {
                                // move one column left
                                E.cx--;
                        // if cursor can be moved one row upwards
                        } else if (E.cy > 0) {
                                // move cursor one row upwards...
                                E.cy--;
                                // ...to the end of line
                                E.cx = E.row[E.cy].size;
                        }
                        break;
                case ARROW_RIGHT:
                        // if cursor column is left of the end of line
                        if (row && E.cx < row->size) {
                                // move the cursor one column right
                                E.cx++;
                        // if cursor is at the end of line
                        } else if (row && E.cx == row->size) {
                                // move cursor on row downwards...
                                E.cy++;
                                // ...to the beginning of the line
                                E.cx = 0;
                        }
                        break;
                case ARROW_UP:
                        // if cursor is not in the top most row
                        if (E.cy != 0) E.cy--;
                        break;
                case ARROW_DOWN:
                        if (E.cy < E.numrows) E.cy++;
                        break;
        }
        
        // get row length
        row = (E.cy >= E.numrows) ? NULL : &E.row[E.cy];
        int rowlen = row ? row->size : 0;
        // if cursor to the right of the end of the line, set it ot end of line
        if (E.cx > rowlen) E.cx = rowlen;
}

/*
 * Process pressed keys
 */
void editor_process_key() {
        int c = editor_read_key();

        // map for control keys
        switch(c) {

                // exit program
                case CTRL_KEY('q'):
                        // clear screen
                        write(STDOUT_FILENO, "\x1b[2J",4);
                        write(STDOUT_FILENO, "\x1b[H", 3);
                        exit(0);
                        break;

                case HOME_KEY:
                        E.cx = 0;
                        break;

                case END_KEY:
                        // cursor above the last row
                        if (E.cy < E.numrows)
                                // move cursor to the last character in line
                                E.cx = E.row[E.cy].size;
                        break;

                case PAGE_UP:
                case PAGE_DOWN:
                        {
                                // position cursor at the top of the screen
                                if (c == PAGE_UP) {
                                        E.cy = E.row_offset;
                                // position cursor at the bottom of the screen
                                } else if (c == PAGE_DOWN) {
                                        E.cy = E.row_offset + E.screenrows - 1;
                                        if (E.cy > E.numrows) E.cy = E.numrows;
                                }
                                int times = E.screenrows;
                                // number of screen rows time arrow keys press
                                while (times--)
                                        editor_move_cursor(c == PAGE_UP ? ARROW_UP : ARROW_DOWN);
                        }
                        break;

                // cursor movement
                case ARROW_UP:
                case ARROW_DOWN:
                case ARROW_LEFT:
                case ARROW_RIGHT:
                        editor_move_cursor(c);
                        break;
        }
}

/*** 
 *
 * Initialize program
 *
 * ***/


/*
 * Initialize editor configuration
 */
void editor_init() {
        // set initial cursor position to top left corner
        E.cx = 0;
        E.cy = 0;
        E.rx = 0;
        E.numrows = 0;
        E.row_offset = 0;
        E.col_offset = 0;
        E.row = NULL;
        E.filename = NULL;

        if(get_window_size(&E.screenrows, &E.screencols) == -1)
                die("editor_init");
        E.screenrows -= 1;
}

int main(int argc, char *argv[]) {
        raw_mode_enable();
        editor_init();

        if (argc >= 2) editor_open(argv[1]);

        while(1) {
                editor_refresh_screen();
                editor_process_key();
        }
        return 0;
}
