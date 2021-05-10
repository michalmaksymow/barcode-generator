import cv2
import subprocess
import time
import re
from print_colors import pcolors


# TODO: FIX THIS MESS
class Test:
    def __init__(self, testDict):
        self.test = testDict

    # TODO: This should be split into multiple methods or functions
    def compare(self):
        expect = self.test["expected"]["checksum"]
        got = self.computed_checksum
        if (str(expect) == str(got)):
            result = pcolors.OKGREEN + "#PASSED" + pcolors.ENDC
        else:
            result = pcolors.FAIL + "#WRONG" + pcolors.ENDC
        print("CHECKSUM - " + result)
        print("Expected: " + str(expect))
        print("Got: " + str(got))

        expect = self.test["expected"]["checksymbol"]
        got = self.computed_checksymbol
        if (str(expect) == str(got)):
            result = pcolors.OKGREEN + "#PASSED" + pcolors.ENDC
        else:
            result = pcolors.FAIL + "#WRONG" + pcolors.ENDC
        print("CHECKSYMBOL - " + result)
        print("Expected: " + str(expect))
        print("Got: " + str(got))

        expect = self.test["expected"]["width"]
        got = self.computed_width
        if (str(expect) == str(got)):
            result = pcolors.OKGREEN + "#PASSED" + pcolors.ENDC
        else:
            result = pcolors.FAIL + "#WRONG" + pcolors.ENDC
        print("CHECKSYMBOL - " + result)
        print("Expected: " + str(expect))
        print("Got: " + str(got))


    # WAY TOO LONG METHOD! WHY AM I DOING THIS?
    def run(self):
        pOutput = ""
        print("")
        print("Running test no. " + pcolors.OKGREEN + str(self.test["id"] + 1) + pcolors.ENDC)
        print("Width of narrow bar: " + pcolors.WARNING + str(self.test["input"]["width"]) + pcolors.ENDC)
        print("Text to encode: " + pcolors.WARNING + str(self.test["input"]["text"]) + pcolors.ENDC)
        print("Running 'java -jar mars.jar barcode_generation.asm'")
        fw = open("tmpout", "wb")
        fr = open("tmpout", "r")
        p = start("java -jar mars.jar barcode_generation.asm")
        read(p) # Skip
        read(p) # Skip
        write(p, str(self.test["input"]["width"]))
        read(p) # Skip
        write(p, str(self.test["input"]["text"]))
        read(p) # Skip

        # Save outputs
        self.computed_checksum = re.search(r'\d+', read(p)).group()
        self.computed_checksymbol = re.search(r'\d+', read(p)).group()
        self.computed_width = re.search(r'\d+', read(p)).group()

        # Wait for program to finish
        p.wait()
        terminate(p)

        # Save generated bmp
        self.image = cv2.imread("../out/output.bmp", 0)
#END TEST CLASS


def start(executable_file):
    return subprocess.Popen(
        executable_file,
        cwd='..', # Run from main directory
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )


def read(process):
    return process.stdout.readline().decode("utf-8").strip()


def write(process, message):
    process.stdin.write(f"{message.strip()}\n".encode("utf-8"))
    process.stdin.flush()


def terminate(process):
    process.stdin.close()
    process.terminate()
    process.wait(timeout=0.2)