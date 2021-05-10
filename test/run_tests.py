import json
from print_colors import pcolors
from test import Test


def __main__():
    print("Starting test execution...")
    print("Loading tests from 'tests.json'")
    tests = loadTests()
    print("Loaded " + str(len(tests)) + " tests!")
    for test in tests:
        runTest(test)


def runTest(test):
    t = Test(test)
    t.run()
    t.compare()
    

def loadTests():
    # Load file
    with open ("tests.json", "r") as tests:
        testsString = tests.read()
    # Convert string to JSON
    testsJson = json.loads(testsString)
    return testsJson


__main__()
