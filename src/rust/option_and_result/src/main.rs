#[test]
fn test_result() {
    let r: Result<i32,&str> = Ok(100);
    assert_eq!(r.unwrap(),100);
    assert_eq!(r.is_ok(), true);
    assert_eq!(r.ok(),Some(100));

    let r: Result<i32,&str> = Err("Error message");
    assert_eq!(r.unwrap_err(),"Error message");
    assert_eq!(r.is_err(), true);
    assert_eq!(r.ok(), None);
    assert_eq!(r.unwrap_or(10),10);
    assert_eq!(r.unwrap_or_default(),0);
}

// Example function returning Option
#[allow(dead_code)]
fn contains(text: &str, char: char) -> Option<&str> {
    // return the input text if it contains char
    if text.chars().any( |c| c == char ) {
        return Some(text);
    // return None if the input text does not contain char
    } else {
        return None;
    }
}

#[test]
fn test_contains() {
    // returns Some(T) since "abc" contains 'a'
    assert_eq!(contains("abc", 'a'), Some("abc"));
    // unwrap a value
    assert_eq!(contains("abc", 'a').unwrap(), "abc");
    // unwrap or panic
    assert_eq!(contains("abc", 'a').expect("Error"), "abc");
    // return None since "abc" does not contain 'd'
    assert_eq!(contains("abc", 'd'), None);
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
    // 4 is an even number
    assert_eq!(is_even(2).is_ok(), true);
    // unwrap Ok(T) yields true 
    assert_eq!(is_even(2).unwrap(), true);
    // 3 is uneven returns with an error
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

    // add_str returns Ok(4) used by and_then as input to return Ok(6)
    assert_eq!(add_str("2","2").and_then(|x| Ok(x + 2)), Ok(6));
    // the and_then closure is never called...
    let result = add_str("x","1").and_then(|x| Ok(x));
    assert_eq!(result.is_err(), true);
}

fn main() {

    // use unwrap_or_else to recover an Err from the is_even method
    let _ = is_even(3).unwrap_or_else(|err| { 
        // print error message
        println!("Three is {}", err);
        // return a bool type
        false
    } );
    
}

