#![no_std]    // disable Rust standard library
#![no_main]   // disable standard program entry point

use core::panic::PanicInfo;
mod vga_buffer;

// function that the compiler should invoke when a panic occurs
// `PanicInfo` parameter contains the file and line where the panic happened
// should never return, diverging function, returning the “never” type `!`
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// `extern "C"` to tell the compiler that it should use the C calling convention
// invoked directly by the operating system or bootloader
// disable compiler name mangling, to keep the function name for the linker
#[no_mangle]
pub extern "C" fn _start() -> ! {

    vga_buffer::print_something();

    loop {}

    // does not return, but invokes the `exit` system call
}
