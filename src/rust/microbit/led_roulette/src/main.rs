#![deny(unsafe_code)]
#![no_std]
// Use the core crate, a subset of std that can run on bare metal systems (i.e., systems without OS
// abstractions like files and sockets).
#![no_main]
// Instead of the standard main we'll use the entry attribute from the cortex-m-rt crate to define
// a custom entry point.

use cortex_m_rt::entry;
use panic_halt as _;
use microbit as _;

// The entry point function must have signature fn() -> !; this type indicates that the function
// can't return -- this means that the program never terminates.
#[entry] 
fn main() -> ! { 
    let _y;
    let x = 42;
    _y = x;
    // infinite loop; just so we don't leave this stack frame
    loop {}
} 
