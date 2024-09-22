# Phobos range test

This is simple program to the zero cost range using the Phobos v2.

The test makes benchmark between a `for` loop and range using phobos.

The CUT (Code Under Test) is as simple pointer list with an inner Range which implements a InputRange.

The List is implemented as a class. The CUT can be compiler as an `FINAL` version or virtual version.

```d
    version(FINAL) {
        final Range opSlice() pure nothrow @nogc {
            return Range(this);
        }
    }
    else {
        Range opSlice() pure nothrow @nogc {
            return Range(this);
        }
    }
```

The CUT can be run with the make tag `run, run-o, run-final, run-final-o`

The sub-tag final means `vesion=FINAL` and the sub-tag `o` means that the CUT is compiled with optimizing.

### First the tests are performed with dmd.

1. CUT without optimizing and virtual opSlice function.
```sh
make clean run DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 3 secs, 731 ms, 520 μs, and 6 hnsecs
benchmark for test   = 2 secs, 469 ms, 526 μs, and 9 hnsecs
Reation 151.103%
```

2. CUT with optimizing and virtual opSlice function.
```sh
make clean run-o DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 4 secs, 52 μs, and 8 hnsecs
benchmark for test   = 1 sec, 174 ms, 416 μs, and 1 hnsec
Reation 340.599%

```

3. CUT without optimizing and final opSilce function.
```sh
make clean run-final DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 4 secs, 456 ms, 204 μs, and 8 hnsecs
benchmark for test   = 3 secs, 10 ms, 169 μs, and 1 hnsec
Reation 148.038%
```

4. CUT wih optimizing and final opSlice function.

```sh
make clean run-final-o DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 4 secs, 685 ms, 181 μs, and 5 hnsecs
benchmark for test   = 984 ms, 39 μs, and 4 hnsecs
Reation 476.117%
```

### The same test using ldc2.

1. CUT without optimizing and virtual opSlice function.
```sh
make clean run

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 6 secs, 93 ms, 225 μs, and 4 hnsecs
benchmark for test   = 2 secs, 335 ms, 440 μs, and 6 hnsecs
Reation 260.903%
```

2. CUT with optimizing and virtual opSlice function.
```sh
make clean run-o

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 1 sec, 5 ms, 914 μs, and 3 hnsecs
benchmark for test   = 9 μs and 7 hnsecs
Reation 10370250.515%
```

3. CUT without optimizing and final opSilce function.

```sh
make clean run-final

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 5 secs, 934 ms, 565 μs, and 8 hnsecs
benchmark for test   = 2 secs, 344 ms, 530 μs, and 7 hnsecs
Reation 253.124%
```

4. CUT with optimizing and final opSlice function.

```sh
make clean run-final-o

LDC - the LLVM D compiler (1.39.0):
range sum = 704982704
for sum   = 704982704
benchmark range test = 145 μs and 2 hnsecs
benchmark for test   = 143 μs and 7 hnsecs
Reation 101.044%

```

## Conclusion
     | virtual | virtual-opt | final | final-opt |
-----+---------+-------------+-------+-----------|
dmd  | 349.6%  | 148.0%      | 476.1% | 260.9%   | 
-----+---------+-------------+-------+-----------|
ldc2 | 260.9%  | 10370250%   | 253.1% | 101.0%   |   
-----+---------+-------------+-------+-----------|



