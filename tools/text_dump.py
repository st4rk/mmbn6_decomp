mmbn6_dict = {
	str(0x0) : ' ',
	str(0x1) : '0',
	str(0x2) : '1',
	str(0x3) : '2',
	str(0x4) : '3',
	str(0x5) : '4',
	str(0x6) : '5',
	str(0x7) : '6',
	str(0x8) : '7',
	str(0x9) : '8',
	str(0xA) : '9',
	str(0xB) : 'A',
	str(0xC) : 'B',
	str(0xD) : 'C',
	str(0xE) : 'D',
	str(0xF) : 'E',
	str(0x10) : 'F',
	str(0x11) : 'G',
	str(0x12) : 'H',
	str(0x13) : 'I',
	str(0x14) : 'J',
	str(0x15) : 'K',
	str(0x16) : 'L',
	str(0x17) : 'M',
	str(0x18) : 'N',
	str(0x19) : 'O',
	str(0x1A) : 'P',
	str(0x1B) : 'Q',
	str(0x1C) : 'R',
	str(0x1D) : 'S',
	str(0x1E) : 'T',
	str(0x1F) : 'U',
	str(0x20) : 'V',
	str(0x21) : 'W',
	str(0x22) : 'X',
	str(0x23) : 'Y',
	str(0x24) : 'Z',
	str(0x26) : 'a',
	str(0x27) : 'b',
	str(0x28) : 'c',
	str(0x29) : 'd',
	str(0x2A) : 'e',
	str(0x2B) : 'f',
	str(0x2C) : 'g',
	str(0x2D) : 'h',
	str(0x2E) : 'i',
	str(0x2F) : 'j',
	str(0x30) : 'k',
	str(0x31) : 'l',
	str(0x32) : 'm',
	str(0x33) : 'n',
	str(0x34) : 'o',
	str(0x35) : 'p',
	str(0x36) : 'q',
	str(0x37) : 'r',
	str(0x38) : 's',
	str(0x39) : 't',
	str(0x3A) : 'u',
	str(0x3B) : 'v',
	str(0x3C) : 'w',
	str(0x3D) : 'x',
	str(0x3E) : 'y',
	str(0x3F) : 'z',
	str(0xA2) : '!',
	str(0xA4) : ',',
	str(0xA9) : "'",
	str(0xB2) : '_',
	str(0xE9) : '\n'
}

def mm_text_to_ascii(text):
	result = ''

	for i in text:
		try:
			result += mmbn6_dict[str(i)]
		except KeyError:
			if i == 0xE6:
				print(result)
				result = ''
			else:
				result = result + ' '

f = open('output_base.gba', 'rb')

#f.seek(0x6C9494)
#f.seek(0x6E8AD0)
#f.seek(0x73991C)
#f.seek(0x7EEB1C)
#f.seek(0x6BCA2C)
#f.seek(0x734CB0)
#f.seek(0x037695)
# 0x87A1AC5
f.seek(0x7A1AC2)
# 86E8AD0

obj = LZ77Compressor()

obj.decompress(f)

#mm_text_to_ascii(text)
