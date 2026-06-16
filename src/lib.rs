pub fn generate(size: u32) -> image::ImageBuffer<image::Luma<u8>, Vec<u8>> {
    use zeno::{Command, Mask, Vector};
    const SQRT_3: f32 = 1.7320508075688772;
    let p = |x: i32, y: i32| {
        Vector::new(
            (x * size as i32) as f32 / 50.0 * SQRT_3,
            (y * size as i32) as f32 / 50.0,
        )
    };
    let path = [
        Command::MoveTo(p(0, -20)),
        Command::LineTo(p(10, -10)),
        Command::LineTo(p(10, 10)),
        Command::LineTo(p(2, 18)),
        Command::LineTo(p(2, 2)),
        Command::LineTo(p(9, 9)),
        Command::LineTo(p(9, -9)),
        Command::LineTo(p(2, -2)),
        Command::LineTo(p(2, 2)),
        Command::LineTo(p(0, 0)),
        Command::LineTo(p(0, -18)),
        Command::LineTo(p(-9, -9)),
        Command::LineTo(p(0, 0)),
        Command::LineTo(p(0, 20)),
        Command::LineTo(p(-10, 10)),
        Command::LineTo(p(-10, -10)),
        Command::Close,
    ];
    let mut path = Mask::new(&path[..]);
    path.size(size, size);
    path.offset(Vector::new(size as f32 * 0.5, size as f32 * 0.5));
    let (mut img, _) = path.render();
    for pixel in &mut img {
        *pixel ^= !0;
    }
    let img = image::GrayImage::from_vec(size, size, img).unwrap();
    img
}
