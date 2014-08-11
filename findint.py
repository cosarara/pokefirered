
import sys
from findstring import findbytes

if __name__ == "__main__":
    s = sys.argv[1]
    fn = sys.argv[2]
    try:
        start = eval(sys.argv[3])
    except:
        start = 0

    if s[:2] == "0x":
        s = s[2:]
    i = int(s, 16)
    b = int(s, 16).to_bytes(len(s)//2, "little")
    with open(fn, "rb") as f:
        fc = f.read()

    findbytes(fc, b, start, False)


