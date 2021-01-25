use std::fs;
use ansi_term::Style;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Options {

    #[structopt(short = "f", long = "file-name")]
    show_file_name: bool,

    #[structopt(name = "FILE", required_if("out-type", "file"))]
    file_name: String

}

fn print_file_name(file_name: &str) {

    println!("--- {} ---\n",
        Style::new()
             .bold()
             .underline()
             .paint(file_name));

}

fn main() {

    let options = Options::from_args();

    // read the content of the file
    match fs::read_to_string(&options.file_name) {

        // on success
        Ok(content) => {
            if options.show_file_name {
                print_file_name(&options.file_name);
            }
            println!("{}",content);
        }

        // on error
        Err(message) => 
            eprintln!("{} {}",&options.file_name,message)

    }
}
