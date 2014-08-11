
import bluespider.text_translate as tt
import sys

def findbytes(fc, ts, start, print_chunk=True):
    d = fc.find(ts, start)
    if d == -1:
        return
    print(hex(d))

    if print_chunk:
        chunk = fc[d:d+100]
        print(tt.hex_to_ascii(chunk))
    findbytes(fc, ts, d+1, print_chunk)

if __name__ == "__main__":
    s = sys.argv[1]
    fn = sys.argv[2]
    try:
        start = eval(sys.argv[3])
    except:
        start = 0

    ts = tt.ascii_to_hex(s)
    with open(fn, "rb") as f:
        fc = f.read()

    findbytes(fc, ts, start)

