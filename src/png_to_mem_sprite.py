from PIL import Image

# Load and resize sprite to 32x32
sprite = Image.open("sprites/test1.png").resize((32, 32))
sprite = sprite.convert("L")  # convert to 8-bit grayscale

with open("sprite.mem", "w") as f:
    for y in range(32):
        for x in range(32):
            pixel = sprite.getpixel((x, y))  # 0-255 grayscale
            f.write("{:02X}\n".format(pixel))  # write as 8-bit hex
