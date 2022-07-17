# 📝 Assembly barcode generator (code39 specification)

Project for my university course in which the task was to build a program in MIPS assembly. The program had to generate a bitmap (.bmp file) containing a correct barcode (according to [code39 specification](https://en.wikipedia.org/wiki/Code_39)) based on a provided string of characters and the width of the narrow bar.

## Usage

In order to run the program, you need to follow these instructions:

1. Obtain the Mars simulator (an integrated environment for running MIPS assembly written in java) available [here](http://courses.missouristate.edu/kenvollmar/mars/download.htm).
2. Run the mars simulator.
3. Open the file `src/barcode_generation.asm`.
4. Compile and run.
5. (Alternatively, instead of running the program in gui mode, one may run it through the console by issuing command
   `java -jar Mars4_5.jar src/barcode_generation.asm`).
6. Generated file will be located in `out/output.bmp`.
