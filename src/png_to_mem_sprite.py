from PIL import Image

# Load and resize sprite to 128 x 128
sprite = Image.open("sprites/player2/walking2.png").resize((128, 128))
# make sure it's RGB
sprite = sprite.convert("RGB")

with open("p2_walking2.mem", "w") as f:
    for y in range(128):
        for x in range(128):
            r, g, b = sprite.getpixel((x, y))  # each channel is 0-255

            # Convert each channel to 4-bit (0-15)
            r4 = r >> 4
            g4 = g >> 4
            b4 = b >> 4

            # Combine into 12-bit RGB444: RRRRGGGGBBBB
            rgb444 = (r4 << 8) | (g4 << 4) | b4

            # Write to file in 3-digit hex
            f.write("{:03X}\n".format(rgb444))
