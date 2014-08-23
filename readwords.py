
import sys

if __name__ == "__main__":
    fn = sys.argv[1]
    adr = eval(sys.argv[2])
    try:
        leng = eval(sys.argv[3])
    except:
        leng = 4

    with open(fn, "rb") as f:
        fc = f.read()

    for i in range(leng):
        a = adr+i*4
        print(".word %s" % hex(int.from_bytes(bytes(fc[a:a+4]), "little")))

