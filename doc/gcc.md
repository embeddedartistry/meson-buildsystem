# GCC Compiler Notes

https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
https://launchpadlibrarian.net/170926122/readme.txt

https://www.evernote.com/shard/s1/nl/19041/2cb5f465-8476-4c99-a330-d6cd750eac08/

You may try to include library headers using -isystem instead of -I. This will make them "system headers" and GCC won't report warnings for them.



Table of Contents
* Installing executables on Linux
* Installing executables on Mac OS X
* Installing executables on Windows
* Invoking GCC
* Architecture options usage
* C Libraries usage
* GCC Plugin usage
* Linker scripts &amp; startup code
* Samples
* GDB Server for CMSIS-DAP based hardware debugger

* Installing executables on Linux *
Unpack the tarball to the install directory, like this:
$ cd $install_dir &amp;&amp; tar xjf gcc-arm-none-eabi-*-yyyymmdd-linux.tar.bz2

For 64 bit system, 32 bit libc and libncurses are required to run the tools.

For some Ubuntu releases, the toolchain can also be installed via
Launchpad PPA at https://launchpad.net/~terry.guo/+archive/gcc-arm-embedded.

* Installing executables on Mac OS X *
Unpack the tarball to the install directory, like this:
$ cd $install_dir &amp;&amp; tar xjf gcc-arm-none-eabi-*-yyyymmdd-mac.tar.bz2

* Installing executables on Windows *
Run the installer (gcc-arm-none-eabi-*-yyyymmdd-win32.exe) and follow the
instructions.

The toolchain in windows zip package is a backup to windows installer for
those who cannot run installer.  We need decompress the zip package
in a proper place and then invoke it following instructions in next section.

* Invoking GCC *
On Linux and Mac OS X, either invoke with the complete path like this:
$ $install_dir/gcc-arm-none-eabi-*/bin/arm-none-eabi-gcc

Or set path like this:
$ export PATH=$PATH:$install_dir/gcc-arm-none-eabi-*/bin
$ arm-none-eabi-gcc

On Windows (although the above approaches also work), it can be more
convenient to either have the installer register environment variables, or run
INSTALL_DIR\bin\gccvar.bat to set environment variables for the current cmd.

For windows zip package, after decompression we can invoke toolchain either with
complete path like this:
TOOLCHAIN_UNZIP_DIR\bin\arm-none-eabi-gcc
or run TOOLCHAIN_UNZIP_DIR\bin\gccvar.bat to set environment variables for the
current cmd.

* Architecture options usage *

This toolchain is built and optimized for Cortex-A/R/M bare metal development.
the following table shows how to invoke GCC/G++ with correct command line
options for variants of Cortex-A/R and Cortex-M architectures.

--------------------------------------------------------------------
| ARM Core | Command Line Options                       | multilib |
|----------|--------------------------------------------|----------|
|Cortex-M0+| -mthumb -mcpu=cortex-m0plus                | armv6-m  |
|Cortex-M0 | -mthumb -mcpu=cortex-m0                    |          |
|Cortex-M1 | -mthumb -mcpu=cortex-m1                    |          |
|          |--------------------------------------------|          |
|          | -mthumb -march=armv6-m                     |          |
|----------|--------------------------------------------|----------|
|Cortex-M3 | -mthumb -mcpu=cortex-m3                    | armv7-m  |
|          |--------------------------------------------|          |
|          | -mthumb -march=armv7-m                     |          |
|----------|--------------------------------------------|----------|
|Cortex-M4 | -mthumb -mcpu=cortex-m4                    | armv7e-m |
|(No FP)   |--------------------------------------------|          |
|          | -mthumb -march=armv7e-m                    |          |
|----------|--------------------------------------------|----------|
|Cortex-M4 | -mthumb -mcpu=cortex-m4 -mfloat-abi=softfp | armv7e-m |
|(Soft FP) | -mfpu=fpv4-sp-d16                          | /softfp  |
|          |--------------------------------------------|          |
|          | -mthumb -march=armv7e-m -mfloat-abi=softfp |          |
|          | -mfpu=fpv4-sp-d16                          |          |
|----------|--------------------------------------------|----------|
|Cortex-M4 | -mthumb -mcpu=cortex-m4 -mfloat-abi=hard   | armv7e-m |
|(Hard FP) | -mfpu=fpv4-sp-d16                          | /fpu     |
|          |--------------------------------------------|          |
|          | -mthumb -march=armv7e-m -mfloat-abi=hard   |          |
|          | -mfpu=fpv4-sp-d16                          |          |
|----------|--------------------------------------------|----------|
|Cortex-R4 | [-mthumb] -march=armv7-r                   | armv7-ar |
|Cortex-R5 |                                            | /thumb   |
|Cortex-R7 |                                            |         |
|(No FP)   |                                            |          |
|----------|--------------------------------------------|----------|
|Cortex-R4 | [-mthumb] -march=armv7-r -mfloat-abi=softfp| armv7-ar |
|Cortex-R5 | -mfpu=vfpv3-d16                            | /thumb   |
|Cortex-R7 |                                            | /softfp  |
|(Soft FP) |                                            |          |
|----------|--------------------------------------------|----------|
|Cortex-R4 | [-mthumb] -march=armv7-r -mfloat-abi=hard  | armv7-ar |
|Cortex-R5 | -mfpu=vfpv3-d16                            | /thumb   |
|Cortex-R7 |                                            | /fpu     |
|(Hard FP) |                                            |          |
|----------|--------------------------------------------|----------|
|Cortex-A* | [-mthumb] -march=armv7-a                   | armv7-ar |
|(No FP)   |                                            | /thumb   |
|----------|--------------------------------------------|----------|
|Cortex-A* | [-mthumb] -march=armv7-a -mfloat-abi=softfp| armv7-ar |
|(Soft FP) | -mfpu=vfpv3-d16                            | /thumb   |
|          |                                            | /softfp  |
|----------|--------------------------------------------|----------|
|Cortex-A* | [-mthumb] -march=armv7-a -mfloat-abi=hard  | armv7-ar |
|(Hard FP) | -mfpu=vfpv3-d16                            | /thumb   |
|          |                                            | /fpu     |
--------------------------------------------------------------------

* C Libraries usage *

This toolchain is released with two prebuilt C libraries based on newlib:
one is the standard newlib and the other is newlib-nano for code size.
To distinguish them, we rename the size optimized libraries as:

  libc.a --&gt; libc_s.a
  libg.a --&gt; libg_s.a

To use newlib-nano, users should provide additional gcc link time option:
 --specs=nano.specs

Nano.specs also handles two additional gcc libraries: libstdc++_s.a and
libsupc++_s.a, which are optimized for code size.

For example:
$ arm-none-eabi-gcc src.c --specs=nano.specs $(OTHER_OPTIONS)

This option can also work together with other specs options like
--specs=rdimon.specs

Please be noticed that --specs=nano.specs is a linker option. Be sure
to include in linker option if compiling and linking are separated.

** additional newlib-nano libraries usage

Newlib-nano is different from newlib in addition to the libraries' name.
Formatted input/output of floating-point number are implemented as weak symbol.
If you want to use %f, you have to pull in the symbol by explicitly specifying
"-u" command option.

  -u _scanf_float
  -u _printf_float

e.g. to output a float, the command line is like:
$ arm-none-eabi-gcc --specs=nano.specs -u _printf_float $(OTHER_LINK_OPTIONS)

For more about the difference and usage, please refer the README.nano in the
source package.

Users can choose to use or not use semihosting by following instructions.
** semihosting
If you need semihosting, linking like:
$ arm-none-eabi-gcc --specs=rdimon.specs $(OTHER_LINK_OPTIONS)

** non-semihosting/retarget
If you are using retarget, linking like:
$ arm-none-eabi-gcc --specs=nosys.specs $(OTHER_LINK_OPTIONS)

* GCC Plugin usage
This release includes following Linux GCC plugins for additional performance
optimization:

** tree_switch_shortcut: optimize (Finite State Machine) FSM style program
to reduce condition jump or indirect jumps. Usage:
(GCC option) -fplugin=tree_switch_shortcut_elf

Please be noticed that current GCC plugin can only run on Linux host. They
are not available to Windows or Mac OS hosted GCC.

* Linker scripts &amp; startup code *

Latest update of linker scripts template and startup code is available on
http://www.arm.com/cmsis

* Samples *
Examples of all above usages are available at:
$install_dir/gcc-arm-none-eabi-*/share/gcc-arm-none-eabi/samples

Read readme.txt under it for further information.

* GDB Server for CMSIS-DAP based hardware debugger *
CMSIS-DAP is the interface firmware for a Debug Unit that connects
the Debug Port to USB.  More detailed information can be found at
http://www.keil.com/support/man/docs/dapdebug/.

A software GDB server is required for GDB to communicate with CMSIS-DAP based
hardware debugger.  The pyOCD is an implementation of such GDB server that is
written in Python and under Apache License.

For those who are using this toolchain and have board with CMSIS-DAP based
debugger, the pyOCD is our recommended gdb server.
More information can be found at https://github.com/mbedmicro/pyOCD.

Currently pyOCD is still in development stage but has a quite active community.
Reporting issues in either our Launchpad website or pyOCD community are welcomed.</pre>
