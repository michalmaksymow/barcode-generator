from print_colors import pcolors
import subprocess


class Test:
    def __init__(self, testDict):
        self.test = testDict

    # WAY TOO LONG FUNCTION
    def run(self):
        print("")
        print("Running test no. " + pcolors.OKGREEN + str(self.test["id"] + 1) + pcolors.ENDC)
        print("Width of narrow bar: " + pcolors.WARNING + str(self.test["input"]["width"]) + pcolors.ENDC)
        print("Text to encode: " + pcolors.WARNING + str(self.test["input"]["text"]) + pcolors.ENDC)
        print("Running 'java -jar mars.jar barcode_generation.asm'")
    