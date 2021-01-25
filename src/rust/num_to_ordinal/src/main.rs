
fn num_to_ordinal(num: u32) -> String {
    // determine the ordinal suffix
    let suffix = match (num % 10, num %100) {
        (1, 1) | (1, 21..=91) => "st",
        (2, 2) | (2, 22..=92) => "nd",
        (3, 3) | (3, 23..=93) => "rd",
        _                     => "th"
    };
    return format!("{}{}",num,suffix);
}

use std::env;
use std::process;

fn main() {
    if env::args().len() == 1 {
        println!("Expects a number as argument!");
        process::exit(1);
    }
    // iterate over all command-line arguments excpet the first
    for argument in env::args().skip(1) {
        // convert string slice to decimal integer
        let result = u32::from_str_radix(argument.as_ref(),10);
        // check the result
        match result {
            // decimal integer value
            Ok(num) => println!("{}",num_to_ordinal(num)),
            // invalid character found
            Err(msg) => println!("{}", msg),
        }
    }
}

#[test]
fn test_num_to_ordinal() {
    assert_eq!(num_to_ordinal(0),"0th");
    assert_eq!(num_to_ordinal(1),"1st");
    assert_eq!(num_to_ordinal(2),"2nd");
    assert_eq!(num_to_ordinal(3),"3rd");
    assert_eq!(num_to_ordinal(12),"12th");
    assert_eq!(num_to_ordinal(22),"22nd");
    assert_eq!(num_to_ordinal(43),"43rd");
}
