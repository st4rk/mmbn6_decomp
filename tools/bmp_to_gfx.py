"""
Experimental code that will convert from BMP format to GBA

each block is 8x8
it's "4bpp", so each byte has two pixel
each pixel is an index in the palette

"""
from PIL import Image
import random

img = Image.open("graphics/licensed.png")

pixels = img.load()

width, height = img.size

gba_gfx = [0] * int((width * height) / 2)

z = 0x0
v = 0x0

debug  = 0
while z < int((width * height) / 2):
	for i in range(0x0, 0x8):
		for j in range(0, 0x4):
			data_1 = int(pixels[(j*2)+v,i][0] / 80)
			data_2 = int(pixels[(j*2+1)+v,i][0] / 80)

			pixel = (data_2 << 0x4) | data_1

			gba_gfx[z + (i*4) + j] = pixel

	v += 0x8
	z += 0x20

f = open("graphics/licensed_by_nintendo_gfx.bin", "wb")
f.write(bytes(gba_gfx))
f.close()
