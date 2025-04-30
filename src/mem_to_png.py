
import sys
from PIL import Image

# Check if the filename is provided as a command-line argument
if len(sys.argv) < 4:
    print("Usage: python mem_to_png.py <mem_filename> <width> <height>")
    sys.exit(1)

# Get the filename and dimensions from the command-line arguments
mem_filename = sys.argv[1]
width = int(sys.argv[2])
height = int(sys.argv[3])

# Create a new image
image = Image.new("RGB", (width, height))
pixels = image.load()

# Read the .mem file
with open(mem_filename, "r") as f:
    lines = f.readlines()

# Ensure the file has the correct number of pixels
if len(lines) != width * height:
    print("Error: The number of pixels in the .mem file does not match the specified dimensions.")
    sys.exit(1)

# Convert each line (RGB444) back to RGB888 and set the pixel
for y in range(height):
    for x in range(width):
        rgb444 = int(lines[y * width + x].strip(), 16)

        # Extract 4-bit R, G, B
        r4 = (rgb444 >> 8) & 0xF
        g4 = (rgb444 >> 4) & 0xF
        b4 = rgb444 & 0xF

        # Convert to 8-bit R, G, B
        r = (r4 << 4) | r4
        g = (g4 << 4) | g4
        b = (b4 << 4) | b4

        # Set the pixel
        pixels[x, y] = (r, g, b)

# Save the image as a PNG file
output_filename = mem_filename.split("/")[-1].split(".")[0] + ".png"
image.save(output_filename)
print(f"Image saved as {output_filename}")