use std::ops::Add;

#[derive(Debug)]
enum EyeColor{
    Blue,
    Green,
    Brown,
    Black
}

#[derive(Debug)]
struct Human {
    name: String,
    height: f32,
    weight: i32,
    age: Option<i32>,
    eye_color: Option<EyeColor>,
}

impl Human {

    fn new(name: String) -> Self {
        Self {
            name,
            age: None,
            height: 0.0,
            weight: 0,
            eye_color: None
        } 
    }

    fn birthday(&mut self) {
       match self.age {
           Some(x) => self.age = Some(x.add(1)),
           None => self.age = None
       }
    }

    fn height(&mut self, height: f32) {
        self.height = height;
    }
    
    fn weight(&mut self, weight: i32) {
        self.weight = weight;
    }

    fn eye_color(&mut self, color: &str) {
        match color {
            "green" => self.eye_color = Some(EyeColor::Green),
            "blue" => self.eye_color = Some(EyeColor::Blue),
            "brown" => self.eye_color = Some(EyeColor::Brown),
            "black" => self.eye_color = Some(EyeColor::Black),
            _ => self.eye_color = None
        }
    }
    
    fn bmi(&self) -> f32 {
        if self.weight <= 0 {
            println!("Weight is not set for {}", self.name);
            return 0.0;
        }
        self.weight as f32 / (self.height * self.height)
    }

    fn adult(&self) -> bool {
        match self.age {
            Some(x) => x >= 18,
            None => false
        }
    }
}

fn main() {

    let mut john = Human {
        name: "John Dow".to_string(),
        height: 1.84,
        weight: 74,
        age: Some(35),
        eye_color: Some(EyeColor::Brown)
    };

    john.birthday();
    println!("{:?} BMI {}", john, john.bmi());

    let mut jane = Human::new("Jane Dow".to_string());
    jane.height(1.67);
    println!("{:?} BMI {} adult? {}", jane, jane.bmi(), jane.adult());
    jane.eye_color("green");

    let mut ben = Human {
        name: "Ben Dow".to_string(),
        ..john
    };
    ben.weight(59);
    println!("{:?} BMI {} adult? {}", ben, ben.bmi(), ben.adult());
}
