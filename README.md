# Phobos range test

This simple program to test the zero cost range using the Phobos v2.

The sample source can be found in the `range_test.d` file in this repository.

The test makes a benchmark between a `for` loop and range using Phobos.

The CUT (Code Under Test) is a simple pointer list with an inner Range that implements a InputRange.

The List is implemented as a class. The CUT can be compiled as an `FINAL` version or virtual version.

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

### First, the tests are performed with dmd.

1. CUT without optimizing and virtual opSlice function.
```sh
make clean run DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 42 secs, 528 ms, 196 μs, and 9 hnsecs
benchmark for test   = 28 secs, 202 ms, 327 μs, and 9 hnsecs
Reation 150.797%
```

2. CUT with optimizing and virtual opSlice function.
```sh
make clean run-o DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 40 secs, 916 ms, 941 μs, and 3 hnsecs
benchmark for test   = 9 secs, 569 ms, 864 μs, and 8 hnsecs
Reation 427.560%
```

3. CUT without optimizing and final opSlice function.
```sh
make clean run-final DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 38 secs, 193 ms, 321 μs, and 2 hnsecs
benchmark for test   = 25 secs, 960 ms, 902 μs, and 1 hnsec
Reation 147.119%
```

4. CUT wih optimizing and final opSlice function.

```sh
make clean run-final-o DMD=1

DMD64 D Compiler v2.109.1
range sum = 49995000
for sum   = 49995000
benchmark range test = 51 secs, 2 ms, and 840 μs
benchmark for test   = 10 secs, 572 ms, 25 μs, and 6 hnsecs
Reation 482.432%
```

### The same test using ldc2.

5. CUT without optimizing and virtual opSlice function.

```sh
make clean run

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 1 minute, 180 ms, 540 μs, and 9 hnsecs
benchmark for test   = 23 secs, 800 ms, 303 μs, and 1 hnsec
Reation 252.856%
```

6. CUT with optimizing and virtual opSlice function.
```sh
make clean run-o

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 11 secs, 66 ms, 150 μs, and 3 hnsecs
benchmark for test   = 10 μs and 5 hnsecs
Reation 105391907.619%
```

7. CUT without optimizing and final opSilce function.

```sh
make clean run-final

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 1 minute, 1 sec, 380 ms, 484 μs, and 2 hnsecs
benchmark for test   = 29 secs, 598 ms, 563 μs, and 1 hnsec
Reation 207.377%
```

8. CUT with optimizing and final opSlice function.

```sh
make clean run-final-o

LDC - the LLVM D compiler (1.39.0):
range sum = 49995000
for sum   = 49995000
benchmark range test = 20 μs
benchmark for test   = 19 μs and 3 hnsecs
Reation 101.027%
```

## Conclusion

The benchmark results are listed below.

| X   | virtual | virtual-opt | final  | final-opt |
|:--- | ----:   | ---:        | ---:   | ---:      |
|dmd  | 349.6%  | 148.0%      | 476.1% | 260.9%    |
|ldc2 | 260.9%  | 10370250%   | 253.1% | 101.0%    |


It's clear to see that the virtual function opSlice in what takes up the time.

For the test bench, it can also be concluded if a final opSlice is used and instead and the code is compiled with ldc2 optimized with \-O3 the range in this case has zero cost.

### This is the code produced by ldc2


*This code is the `range_sum` function with the virtual opSlice.*


```asm
nothrow @nogc @safe int example.range_sum(example.List!(int).List):
        push    rax
        mov     rax, qword ptr [rdi]
        call    qword ptr [rax + 48] /// virtual function call
        xor     ecx, ecx
        test    rax, rax
        je      .LBB0_3
.LBB0_1:
        add     ecx, dword ptr [rax + 8]
        mov     rax, qword ptr [rax]
        test    rax, rax
        jne     .LBB0_1
.LBB0_3:
        mov     eax, ecx
        pop     rcx
        ret
```

This is the for loop.
```asm
nothrow @nogc @safe int example.for_sum(example.List!(int).List):
        mov     rcx, qword ptr [rdi + 16]
        xor     eax, eax
        test    rcx, rcx
        je      .LBB3_3
.LBB3_1:
        add     eax, dword ptr [rcx + 8]
        mov     rcx, qword ptr [rcx]
        test    rcx, rcx
        jne     .LBB3_1
.LBB3_3:
        ret

```

So the only difference is the indirect function call and the stack cleanup.


*This code is produced with \-O3 and the final opSlice function.*



```asm
nothrow @nogc @safe int example.range_sum(example.List!(int).List):
        mov     rcx, qword ptr [rdi + 16]
        xor     eax, eax
        test    rcx, rcx
        je      .LBB0_3
.LBB0_1:
        add     eax, dword ptr [rcx + 8]
        mov     rcx, qword ptr [rcx]
        test    rcx, rcx
        jne     .LBB0_1
.LBB0_3:
        ret

```

This is the for loop

```asm
nothrow @nogc @safe int example.for_sum(example.List!(int).List):
        mov     rcx, qword ptr [rdi + 16]
        xor     eax, eax
        test    rcx, rcx
        je      .LBB3_3
.LBB3_1:
        add     eax, dword ptr [rcx + 8]
        mov     rcx, qword ptr [rcx]
        test    rcx, rcx
        jne     .LBB3_1
.LBB3_3:
        ret
```


The code produced by ldc2 is in this case the same.

**This means we have zero cost in this case.**  
