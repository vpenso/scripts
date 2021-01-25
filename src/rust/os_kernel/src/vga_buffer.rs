// disable warnings for unused elements
#[allow(dead_code)]
// enable copy semantics 
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
// list of all available colors
pub enum Color {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    Pink = 13,
    Yellow = 14,
    White = 15,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(transparent)]
struct ColorCode(u8);

// represent a full color code that specifies foreground and background color
impl ColorCode {
    fn new(foreground: Color, background: Color) -> ColorCode {
        ColorCode((background as u8) << 4 | (foreground as u8))
    }
}

// Structure representing a screen character
// including the ASCII character as well as
// its corresponding color configuration
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(C)] // garantee field ordering (like C)
struct ScreenChar {
    ascii_character: u8,
    color_code: ColorCode,
}

// Dimensions of the text buffer 25 rows by 80
// columns
const BUFFER_HEIGHT: usize = 25;
const BUFFER_WIDTH: usize = 80;

use volatile::Volatile;

#[repr(transparent)]
struct Buffer {
    // `Volatile` is a generic wrapper for memory access
    // and prevents compiler optimization
    chars: [[Volatile<ScreenChar>; BUFFER_WIDTH]; BUFFER_HEIGHT],
}

// Write the last line, and shift to the next
// line at EOL
pub struct Writer {
    // current posistion in the last row
    column_position: usize,
    // current fore/background color
    color_code: ColorCode,
    // VGA buffer
    buffer: &'static mut Buffer,
    // valid for the liftime of the program
}

impl Writer {

    // called on new line 
    fn new_line(&mut self) { /*TODO*/ }

    // write a single ASCII byte
    pub fn write_byte(&mut self, byte: u8) {
        match byte {
            b'\n' => self.new_line(),
            // non new-line characters
            byte => {
                if self.column_position >= BUFFER_WIDTH {
                    self.new_line();
                }

                let row = BUFFER_HEIGHT - 1;
                let col = self.column_position;

                let color_code = self.color_code;
                self.buffer.chars[row][col].write(
                    ScreenChar {
                        ascii_character: byte,
                        color_code,
                    }
                );
                self.column_position += 1;
            }
        }
    }

    // print a string
    pub fn write_string(&mut self, s: &str) {
        // iterate of the input string byte-by-byte
        for byte in s.bytes() {
            match byte {
                // printable ASCII byte or newline
                0x20..=0x7e | b'\n' => self.write_byte(byte),
                // not part of printable ASCII range (i.e. UTF-8)
                _ => self.write_byte(0xfe),
            }
        }
    }
}

pub fn print_something() {
    let mut writer = Writer {
        column_position: 0,
        color_code: ColorCode::new(Color::Yellow, Color::Black),
        buffer: unsafe { &mut *(0xb8000 as *mut Buffer) },
    };

    writer.write_byte(b'H');
    writer.write_string("ello ");
    writer.write_string("Wörld!");
}
