#!/usr/bin/rdmd 
// Type your code here, or load an example.
import std.algorithm;
import std.range;
import std.conv;

@safe:
class List(T) {
    static struct Element {
        Element* next;
        T value;
    }
    Element* head;
    void add(T x) {
        if (head is null) {
            head =  new Element(null, x);
            return;
        }
        head = new Element(head, x);
    }

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

    @nogc
    static struct Range {
        protected Element* current;
        this(List owner) pure nothrow {
            current=owner.head;    
        }
        pure nothrow {
            bool empty() const {
                return current is null;
            }
            T front() {
                return current.value;
            }
            void popFront() {
                if (current) {
                    current = current.next;
                }
            }
        }
    }
}

int range_sum(List!int l)  nothrow @nogc {
    return l[].sum;
}

int for_sum(List!int l)  nothrow @nogc {
    List!(int).Element* c;
    int result;
    for(c=l.head; c !is null; c=c.next) {
        result+=c.value;
    }
    return result;
}

import std.stdio;
import std.datetime.stopwatch;
void main() {
    auto l=new List!int;
    enum number_of_elements=10_000;
    number_of_elements.iota.each!(n => l.add(n));

    const range_result = range_sum(l);
    const for_result = for_sum(l);
    writefln("range sum = %d", range_result);
    writefln("for sum   = %d", for_result);
    assert(range_result == for_result, "The results should be the same");
    enum number_of_tests = 1_000_000;
    void range_test() {
        range_sum(l);
    }
    void for_test() {
        for_sum(l);
    }
    auto r = benchmark!(range_test, for_test)(number_of_tests);
    writefln("benchmark range test = %s", r[0]);
    writefln("benchmark for test   = %s", r[1]);
    const range_dur =double(r[0].total!"nsecs");
    const for_dur =double(r[1].total!"nsecs");

    writefln("Reation %.3f%%", range_dur/for_dur*100);
}
