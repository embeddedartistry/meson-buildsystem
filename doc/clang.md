# Clang Build Notes

## Compiler Flags
-fno-builtin            Disable implicit builtin knowledge of functions



-fno-wchar              Disable C++ builtin type wchar_t

  -fshort-enums           Allocate to an enum type only as many bytes as it needs for the declared range of possible values

  -fshort-wchar           Force wchar_t to be a short unsigned int

-fsjlj-exceptions       Use SjLj style exceptions

-fwrapv                 Treat signed integer overflow as two's complement

Clang args to investigate
-fforbid-guard-variables
                          Emit an error if a C++ static local initializer would need a guard variable
  -finstrument-functions  Generate calls to instrument function entry and exit
 -fix-only-warnings      Apply fix-it advice only for warnings, not errors
  -fix-what-you-can       Apply fix-it advice even in the presence of unfixable errors
  -fixit-recompile        Apply fix-it changes and recompile
  -fixit-to-temporary     Apply fix-it changes to temporary files
  -fixit=<value>          Apply fix-it advice creating a file with the given suffix
  -fixit                  Apply fix-it advice to the input source
  -flimit-debug-info      Limit debug information produced to reduce size of debug binary

-gcc-toolchain <value>  Use the gcc toolchain at the given directory

-isysroot <dir>         Set the system root directory (usually /)

  -menable-no-infs        Allow optimization to assume there are no infinities.

  -menable-no-nans        Allow optimization to assume there are no NaNs.
  -menable-unsafe-fp-math Allow unsafe floating-point math optimizations which may decrease precision

  -mstack-alignment=<value>

                          Set the stack alignment
  -mstackrealign          Force realign the stack at entry to every function.


-undef                  undef all system defines


  -stack-protector-buffer-size <value>

                          Lower bound for a buffer to be considered for stack protection
  -stack-protector <value>
                          Enable stack protectors


Doesn't seem to be defined?

    stdlib_compiler_flags += [
        #  Disable standard system #include directories
        '-nostdsysteminc'
    ]
