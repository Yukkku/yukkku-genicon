fn main() {
    let cmd = clap::command!();
    cmd.get_matches();
    let img = yukkku_genicon::generate(360);
    img.save("./result.png").unwrap();
}
