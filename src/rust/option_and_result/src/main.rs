
// Check if a text string contains a specific character
//
fn contains(text: &str, char: char) -> Option<&str> {
    if text.chars().any( |c| c == char ) {
        return Some(text);
    } else {
        return None;
    }
}

fn is_even(number: i32) -> Result<bool,&'static str> {
    if number % 2 == 0{
        return Ok(true);
    } else {
        return Err("Not an even");
    }
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

    // three is an uneven number returning Err
    let _ = is_even(3).unwrap_or_else(|err| { 
        // print error message
        println!("Three {}", err);
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

#[test]
#[should_panic(expected = "Error message")]
fn test_contains_none() {
    // text "abc" does not contain character 'd', returns None
    // expect evaluates to the error message
    contains("abc",'d').expect("Error message");
}

#[test]
fn test_is_even_err() {
    assert_eq!(is_even(3).is_err(),true);
}