// structures package together multiple related values that make up a meaningful group

// define a structure with debugging functionality
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

// define associated function
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width >= other.width && self.height >= other.height
    }
}

fn main() {
    let big_rectangle = Rectangle {
        width: 30,
        height: 50
    };

    println!("{:?} with area {}", big_rectangle, big_rectangle.area());

    let small_rectanlge = Rectangle::square(20);
    println!("{:?} can hold big rectanlge? {}", 
        small_rectanlge,
        small_rectanlge.can_hold(&big_rectangle)
    );

    let similar_rectangle = Rectangle {
        width: 100,
        ..big_rectangle
    };
    println!("{:?} can hold big rectangle? {}", 
        similar_rectangle,
        similar_rectangle.can_hold(&big_rectangle)
    );
}