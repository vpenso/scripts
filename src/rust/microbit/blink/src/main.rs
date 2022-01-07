// disable the standard library using only the core crate
#![no_std]
// replace the operating system entry point
#![no_main]

// implementation of the RTT (Real-Time Transfer) I/O protocol to 
// transfer data between host and target device (probe)
use rtt_target::{rtt_init_print, rprintln};
// logs panic messages over RTT
use panic_rtt_target as _;

// contains a range of hardware abstraction traits which can are
// implemented by board specific crates.
use embedded_hal::{blocking::delay::DelayMs, digital::v2::OutputPin};

// contains the interface too the BBC micro:bit 
use microbit::{board::Board, hal::timer::Timer};

// cortex_m_rt implements the minimal startup and runtime for Cortex-M 
// microcontrollers,  and defines the entry point of the program.
#[cortex_m_rt::entry]
fn main() -> ! {  // return type of ! means that the function cannot return. 
                  // An easy way to implement this is to use an infinite loop.

    // RTT convenience macro initializes printing on channel 0
    rtt_init_print!();
    rprintln!("Boot board...");
    
    // return an instance of the board the first time it is called
    let mut board = Board::take().unwrap();

    // GPIO pins connected to the LED matrix
    let _ = board.display_pins.col1.set_low();
    let mut row1 = board.display_pins.row1;

    let mut timer = Timer::new(board.TIMER0);

    loop {
        let _ = row1.set_low();
        timer.delay_ms(1_000_u16);
        let _ = row1.set_high();
        timer.delay_ms(1_000_u16);
    }
    
}
