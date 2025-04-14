from PIL import Image

img = Image.open("backgrounds_png/background_1.png").resize((640, 480))
img = img.convert("RGB")

with open("background.mem", "w") as f:
    for y in range(480):
        for x in range(640):
            r, g, b = img.getpixel((x, y))
            r4 = r >> 4
            g4 = g >> 4
            b4 = b >> 4
            rgb12 = (r4 << 8) | (g4 << 4) | b4
            f.write("{:03X}\n".format(rgb12))
