#![no_std]
// Use the core crate, a subset of std that can run on bare metal systems (i.e., systems without OS
// abstractions like files and sockets).
#![no_main]
// Instead of the standard main we'll use the entry attribute from the cortex-m-rt crate to define
// a custom entry point.

use panic_rtt_target as _;
use rtt_target::{rtt_init_print, rprintln};

use cortex_m_rt::entry;

#[entry]
fn main() -> ! { 
    rtt_init_print!();
    rprintln!("Hello World");
    loop {}
    // function can't return -- this means that the program never terminates
} 
