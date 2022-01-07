#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_rtt_target as _;
use rtt_target::{rtt_init_print, rprintln};
use microbit::{board::Board, hal::timer::Timer};
use embedded_hal::{blocking::delay::DelayMs, digital::v2::OutputPin};

#[entry]
fn main() -> ! {

    rtt_init_print!();
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
