"""
Experimental code that will convert from GBA format to BMP

each block is 8x8
it's "4bpp", so each byte has two pixel
each pixel is an index in the palette

"""
from PIL import Image
import random

b = open("graphics/licensed_by_nintendo_gfx.bin", "rb")

gba_gfx = b.read()

b.close()

img = Image.new('RGB', (112,8))

pixels = img.load()

z = 0x0
v = 0x0

debug  = 0
while z < 0x1C0:
	for i in range(0x0, 0x8):
		for j in range(0, 0x4):
			pixel_value = gba_gfx[z + (i*4) + j]

			delta = pixel_value & 0xF;
			pixels[(j*2)+v,i] = (80*delta,80*delta, 80*delta)
			delta = (pixel_value >> 0x4) & 0xF

			pixels[(j*2+1)+v,i] = (80*delta, 80*delta, 80*delta)

			debug += 1

	v += 0x8
	z += 0x20


img.show()
img.save("graphics/licensed.png")