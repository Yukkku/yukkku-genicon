use clap::Parser;
use yukkku_genicon::generate;

#[derive(Parser)]
struct Args {
    size: u32,
    file: String,
}

fn main() -> Result<(), image::ImageError> {
    let Args { size, file } = Args::parse();
    let img = generate(size);
    img.save(file)
}
