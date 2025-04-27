import sys
from PIL import Image

# Check if the filename is provided as a command-line argument
if len(sys.argv) < 2:
    print("Usage: python png_to_mem_sprite.py <image_filename>")
    sys.exit(1)

# Get the filename from the command-line arguments
filename = sys.argv[1]

# Load the sprite
sprite = Image.open(filename)

# Get the dimensions of the image
width, height = sprite.size

# Make sure it's RGB
sprite = sprite.convert("RGB")

# Generate the output filename based on the input filename
output_filename = filename.split("/")[-1].split(".")[0] + ".mem"

with open(output_filename, "w") as f:
    for y in range(height):
        for x in range(width):
            r, g, b = sprite.getpixel((x, y))  # each channel is 0-255

            # Convert each channel to 4-bit (0-15)
            r4 = r >> 4
            g4 = g >> 4
            b4 = b >> 4

            # Combine into 12-bit RGB444: RRRRGGGGBBBB
            rgb444 = (r4 << 8) | (g4 << 4) | b4

            # Write to file in 3-digit hex
            f.write("{:03X}\n".format(rgb444))