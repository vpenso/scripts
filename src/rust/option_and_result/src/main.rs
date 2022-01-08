
// Check if a text string contains a specific character
//
fn contains(text: &str, char: char) -> Option<&str> {
    if text.chars().any( |c| c == char ) {
        return Some(text);
    } else {
        return None;
    }
}

fn main() {
    let text = contains("abc",'a');
    let none = contains("abc",'d');

    println!("{:?}", text);          // Some(abc)
    println!("{:?}", none);          // None
    println!("{:?}", text.unwrap()); // "abc"

    match contains("abc",'a') {
        Some(text) => println!("{:?}", text),    // "abc"
        None => println!("Character not in text!"),
    }
}
