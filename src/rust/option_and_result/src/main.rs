
// Example function returning Option
//
fn contains(text: &str, char: char) -> Option<&str> {
    if text.chars().any( |c| c == char ) {
        return Some(text);
    } else {
        return None;
    }
}

#[test]
fn test_contains() {
    assert_eq!(contains("abc", 'c').unwrap(), "abc");
}

#[test]
#[should_panic(expected = "Error message")]
fn test_contains_panic() {
    // text "abc" does not contain character 'd', returns None
    // expect evaluates to the error message
    contains("abc",'d').expect("Error message");
}


// Example function returning Result
//
fn is_even(number: i32) -> Result<bool,&'static str> {
    if number % 2 == 0{
        return Ok(true);
    } else {
        return Err("not an even");
    }
}

#[test]
fn test_is_even() {
    assert_eq!(is_even(4).is_ok(), true);
    assert_eq!(is_even(3).is_err(),true);
}

use core::num::ParseIntError;
#[allow(dead_code)]
fn add_str(x: &str, y: &str) -> Result<i32, ParseIntError> {
    // use the question mark operator to unwrap a result...
    // ..or to return with en ParseInError 
    let x: i32 = x.parse()?;
    let y: i32 = y.parse()?;
    Ok(x + y)
}

#[test]
fn test_add_str() {
    // parses both string to integers and returns the sum
    assert_eq!(add_str("2", "2").unwrap(), 4);
    // parse a non numeral string results in an error
    assert_eq!(add_str("2", "a").is_err(), true);
}

fn main() {
    let text = contains("abc",'a');
    let none = contains("abc",'d');

    println!("{:?}", text);          // Some(abc)
    println!("{:?}", none);          // None
    println!("{:?}", text.unwrap()); // "abc"

    // match character 'a' in text "abc", expect unwraps 'abc' without error
    let text = contains("abc", 'a').expect("Error message");
    println!("{}",text); // abc

    // two is an even number...
    println!("Is two even? {}", is_even(2).unwrap()); // true

    // use unwrap_or_else to recover an Err from the is_even method
    let _ = is_even(3).unwrap_or_else(|err| { 
        // print error message
        println!("Three is {}", err);
        // return a bool type
        false
    } );
    
    match contains("abc",'a') {
        Some(text) => println!("{:?}", text),    // "abc"
        None => println!("Character not in text!"),
    }
    
}


#[test]
fn test_result() {
    // test for an Ok(T) on a Result
    let r: Result<i32,&str> = Ok(100);
    assert_eq!(r.unwrap(),100);
    assert_eq!(r.is_ok(), true);
    assert_eq!(r.ok(),Some(100));

    // test for an Err(E) on a Result
    let r: Result<i32,&str> = Err("Error message");
    assert_eq!(r.unwrap_err(),"Error message");
    assert_eq!(r.is_err(), true);
    assert_eq!(r.ok(), None);
    assert_eq!(r.unwrap_or(10),10);
    assert_eq!(r.unwrap_or_default(),0);
}
