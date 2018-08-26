# Cross Compiling

These are notes for future reference


Great cross example:

https://github.com/jpakkane/mesonarduino/blob/master/arduino_uno_cross.txt
https://github.com/jpakkane/mesonarduino/blob/master/meson.build
STM32F3Discovery-meson-example (meson)





STM32F3Discovery-meson-example (meson)

We have to get deeper into meson!
We start with an examination of the meson cross-file
cross-file

We have to tell meson which compilers it should use: In our case the llvm-compiler
[binaries]
c       = 'clang-5.0'
cpp     = 'clang++-5.0'
ld      = 'llvm-link-5.0'
ar      = 'llvm-ar-5.0'
as      = 'llvm-as-5.0'
size    = 'llvm-size-5.0'
objdump = 'llvm-objdump-5.0'
objcopy = 'arm-none-eabi-objcopy'
after that we have to define some compiler flags. These are copied directly at the compilation to the specific compilers / linkers
[properties]
c_args      = [
               '--target=arm-none-eabi',    # define target for clang
               '-mthumb',                   # define language
               #------------------------------------
               '-fshort-enums',             # otherwise errors at linking...
               '-fmessage-length=0',        # all error warnings in a single line (default 72)
               '-fsigned-char',             # char is per default unsigned
               '-ffunction-sections',       # each function to a seperate section ==> Code-optimization / deletion
               '-fdata-sections',           # each variable to a seperate section ==> Code-optimization / deletion


               '-Weverything',
               '-ffreestanding',
               '-v', # option for more verbose output
               ]


c_link_args = [
              '--target=arm-none-eabi', # define target for linker
              '-v',                     # option for more verbose output
               '-nostdlib',             # do not import the standard library's
]
these are the bare minimum what we have to define for a compilation with llvm.
okay i lied…
you need also the -mcpu flag, the linker and startup files and also link the thumbv6 or thumbv7 runtimes. But this will follow shortly
back to the cross-file.
[host_machine]
system     = 'none'
cpu_family = 'arm'
cpu        = 'cortex-m4'
endian     = 'little'
At the end we have to define our host_machine. Meson define the host_machine as the machine that runs the compilated code. And in most cases this is equal to the target_machine.
meson.build

The meson.build file defines our executable and I also added some nice features for developing with STM32 Devices.
First we define the project name and default options.
project('blink', 'c',
          default_options : ['b_lto=false',
                             'b_asneeded=false'])
And after that we define some variables.
# uController / HAL Driver dependend options
c_args     += '-DSTM32F303xC'    # HAL Driver define
linkfiles   = files(['STM32-ldscripts/STM32F3/STM32F303VC.ld', 'STM32-ldscripts/simple.ld'])
startupfile = files(['STM32-startup/STM32F3/stm32f303xc.s'])
We have to add define the STM32F303xC flag for the compilation with the STM32Cube library. this is equivalent to
#define(STM32F303xC)
in a C file.
Also we have to add the linkfiles and startup files to a variable. When we define paths with the files function, meson will save the absolute file path. So we don’t have to mess around with filenames when we concatenate meson.build files to create more complex projects.
create linker flags

Now we can use a string replace function and a foreach loop to create our linker-flags with an absolute path to our linker files
foreach linkfile : linkfiles
 link_args += ['-Wl,-T,@0@/@1@'.format(meson.current_source_dir(), linkfile)]
endforeach
a convenience function

Now follows a convenience function:
cpu = host_machine.cpu() == 'cortex-m0+' ? 'cortex-m0plus' : host_machine.cpu()
c_args += '-mcpu=@0@'.format( cpu )
we take the already define variable from the host_machine definition and define our compiler flag -mcpu. Sadly the Cortex-M0+ has another syntax. It can’t use the plus sign. So we have to make this if else
link runtime  and header

It follows another a convenience function
arch       = (host_machine.cpu() == 'cortex-m0') or (host_machine.cpu() == 'cortex-m0+') or (host_machine.cpu() == 'cortex-m1') ? 'armv6-m'  : ''
arch      += (host_machine.cpu() == 'cortex-m3') ?                                                                                'armv7-m'  : ''
arch      += (host_machine.cpu() == 'cortex-m4') or (host_machine.cpu() == 'cortex-m7') ?                                         'armv7e-m' : ''


link_deps +=  meson.get_compiler('c').find_library('/usr/lib/gcc/arm-none-eabi/4.9.3/@0@/libgcc'.format(arch))
dependent on the cpu architecture we have to load different runtimes from the arm-none-eabi-gcc toolchain. Here we just mangling around path names.
And for the llvm-toolchain only I had to link manually the right header files to our project.
if meson.get_compiler('c').get_id() == 'clang'
  incdirs += include_directories('/usr/lib/arm-none-eabi/include/') # bare-metal : std header includes
endif
Also the include_directories function will mangling around the path to an absolute path for easier usage.
Why did I had to do this? I didn’t compile the so called llvm runtime compiler-rt for our Cortex-M targets. This would have created the runtime from the standard llvm toolchain. Something I want to do in the future.
include STM32Cube library

In the folder STM32Cube-F3-meson there is also a meson.build file.
# add STM library
subdir('STM32Cube-F3-meson')
with this command we tell meson to look in that directory for another meson.build file and execute it. All variables will be present in the root meson.build file
define executable

main = executable(
            'main.elf',
            [srcs, stm32cube_srcs, 'main.c', startupfile] ,
            c_args              : [c_args ],
            link_args           : [link_args, '-Wl,--gc-sections'],
            dependencies        : link_deps,
            include_directories : [incdirs, stm32cube_incdirs] )
finally we can define our executable.
It’s mostly self explanatory. We create an output file with the name main.elf. We include all defined source files, the STM32Cube sources, the main.c and startupfiles.
We use the compiler with the flags defined in c_args and afterwards link it with the flags from link_args. I added also the -Wl,--gc-sections flag. This tells the compiler to use garbage collection and strips out unused code.
Then we add the runtime dependencies saved in the link_deps variable. And last but not leas we tell the compiler where to look for header files.
custom targets

At the end of the file I added some custom targets. These command can be called by meson directly or are just called in every ninja run if the build_by_default flag is set to true
...
maindump = custom_target(
                        'dump',
      capture          : true,
      output           : ['main.dump'],
      command          : [objdump, '-triple=thumbv6m-none-eabi', '-disassemble-all', '-S', '-t', 'main.elf', '>', 'main.dump'],
      depends          : [main])
...
I used this custom target make copies of the executable to different file formats and dump files.




STM32F3Discovery-meson-example (enhanced commands)

Source URL:https://hwengineer.github.io/discovery_enhanced/




STM32F3Discovery-meson-example (enhanced commands)

With meson it is easy to extend some useful bash command
usually I forgot the commands to type in the terminal for debugging in about a few days…


Thats why I decided to use a nice feature from meson.
run_target

On the last few lines of the meson.build file I defined some commands:
meson.build
run_target('gdb',
         command : [terminal, '--working-directory=@0@'.format(meson.source_root()), '-e', gdb, '-q', '@0@/main.elf'.format(meson.current_build_dir())])


run_target('openocd',
         command : [terminal, '-e', openocd, '-f', 'interface/stlink-v2.cfg', '-f' , 'target/stm32f3x.cfg'])
I can now run in the build folder the following command : ninja openocd that starts an openocd session.


And with ninja gdb I start a new gdb session.
Both commands get executed in a new terminal and gdb loads the .gdbinit file automatically.
.gdbinit
target remote :3333


layout src
load
I just have to type in (gdb)continue in the gdb shell to start my program.
gdb auto-load save path

for security reasons you maybe have to enable your working directory to load a .gdbinit file.


the brute force variant is to enable all paths.
~/.gdbinit
set auto-load safe-path /
    Written on January  8, 2018




GCC integration

    Source URL: https://hwengineer.github.io/GCC_integration/


GCC integration

Due to some request I added gcc support

It was nice to see that only minor changes had to be made.
I added a new cross-file : cross_gcc.build

Firstly you have to change all compiler commands to the gcc related binaries.
cross_gcc.build
[binaries]
c       = 'arm-none-eabi-gcc'
cpp     = 'arm-none-eabi-g++'
ld      = 'arm-none-eabi-ld'
ar      = 'arm-none-eabi-ar'
as      = 'arm-none-eabi-as'
size    = 'arm-none-eabi-size'
objdump = 'arm-none-eabi-objdump'
objcopy = 'arm-none-eabi-objcopy'
strip   = 'arm-none-eabi-strip'
gdb     = 'arm-none-eabi-gdb'
And I had to strip some llvm specific compile and link flags.
[properties]
c_args      = [
               #'--target=arm-none-eabi',   # llvm specific
               '-mthumb',                   # define language
               #------------------------------------
               '-fshort-enums',             # otherwise errors at linking...
               '-fmessage-length=0',        # all error warnings in a single line (default 72)
               '-fsigned-char',             # char is per default unsigned
               '-ffunction-sections',       # each function to a seperate section ==> Code-optimization / deletion
               '-fdata-sections',           # each variable to a seperate section ==> Code-optimization / deletion

               #'-Weverything',             # llvm specific
               '-Wall',
               '-ffreestanding',
               ]

c_link_args = [
               #'--target=arm-none-eabi', # llvm specific
               '-nostdlib',               # do not import the standard library's
              ]
done
examples

I added and test the files on my examples repo.
git clone https://github.com/hwengineer/STM32F3Discovery-meson-example.git
cd STM32F3Discovery-meson-example
mkdir gccbuild
meson gccbuild --cross-file=cross_gcc.build
cd gccbuild
ninja
git clone https://github.com/hwengineer/STM32-L0-qemu-example.git
cd STM32-L0-qemu-example
mkdir gccbuild
meson gccbuild --cross-file=cross_gcc.build
cd gccbuild
ninja
    Written on January 24, 2018


ld.lld and linker files

    Source URL: https://hwengineer.github.io/linker/


ld.lld and linker files

LLVM’s linker was a real pain…
LLVM linker (ld.lld-5.0)

To get my STM32 to run I have to tell the linker where to store the executable data.

This is usually done with a linker file. But unfortunately ld.lld doesn’t support the same gcc-linker syntax.
Memory definition

We first start with the memory definition file

```
STM32-linker/STM32F3/STM32F303VC.ld
MEMORY{
    RAM    (xrw)  : ORIGIN = 0x20000000, LENGTH = 40K
    FLASH  (rx)   : ORIGIN = 0x08000000, LENGTH = 256K
    CCMRAM (xrw)  : ORIGIN = 0x10000000, LENGTH = 8K
}
```

The STM32F303VC6 which is used in the STM32F3Discovery board is defined by this (mem) linker file. We see that this Chip has a RAM region in 0x20000000 which is 40KB long and used for saving variables and the stack. Also it has a FLASH region for the program code at the adress 0x0800000 which is 256KB long.

And we just ignore the CCMRAM.
(simple) linker file

Now we want to define a simple linker file. We tell meson in the meson.build file to use the memory layout file and append the simple linker file together. So we have a uC agnostic linker file and for every uC an independent memory layout file.
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")

```
/* define entry point */
ENTRY(Reset_Handler)
```
first we have some configuration shenanigans. Without any further explanation.

Then starts the black magic

```
/* calculate the Last RAM address*/
 _estack = ORIGIN(RAM) + LENGTH(RAM) - 1;
we first define a variable with the the start-address of the stack pointer. It will be on the top of the RAM memory.
SECTIONS
{
    /*--------------------------------------------------------------------------*/
  /* interrupt vector goes at the beginning of FLASH */
    .isr_vector : {
            . = ALIGN(4);                    /* align */
            _sisr_vector = .;     /* define start symbol */
            KEEP(*(.isr_vector))  /* Interrupt vectors */
            . = ALIGN(4);                    /* align */
            _eisr_vector = .;            /* define end symbol */
  } > FLASH
```

then we define the first memory entry in the FLASH memory. It’s the interrupt vector table.
define a section

this syntax defines a block with the name .<region> which going to be saved in the FLASH memory

```
 .<region> : {
   ...
 } > FLASH
```

The command `KEEP(*(.isr_vector))` will copy the section defined in the startupfile with the name .isr_vector in the surrounding <region>.
Sadly I used the same name for region and the section defined in the startupfile.
next we copy the program code and constant values to the FLASH memory

```
  /*--------------------------------------------------------------------------*/
  /* program data goes into FLASH */
  .text : {
      . = ALIGN(4);                    /* align */
      _stext = .;           /* define start symbol */
      *(.text)                          /* insert program code .text */
      *(.text*)             /* .text* sections */

      *(.glue_7)            /* glue arm to thumb code */
      *(.glue_7t)           /* glue thumb to arm code */
      *(.eh_frame)

      . = ALIGN(4);                  /* align */
      _etext = .;           /* define end symbol */
  } > FLASH
  /*--------------------------------------------------------------------------*/
  /* constant data goes into FLASH */
  .rodata : {
     *(.rodata)            /* .rodata sections (constants, strings, etc.) */
     *(.rodata*)           /* .rodata* sections (constants, strings, etc.) */
     . = ALIGN(4);         /* align */
      _erodata = .;
  } > FLASH
As you can read in the comments : *(.text) is the program code and the glue sections are some special arm / thumb magic.
then follows some more arm magic
/* ARM stack unwinding section (GDB uses this) */
.ARM.extab : {
     __extab_start__ = .;/* define start symbol */
     *(.ARM.extab* .gnu.linkonce.armextab.*)
     __extab_end__ = .;  /* define end symbol */
} > FLASH

.ARM : {
     __exidx_start__ = .;/* define start symbol */
     *(.ARM.exidx* .gnu.linkonce.armexidx.*)
     __exidx_end__ = .;  /* define end symbol */
} > FLASH
```

Initialized globals

Then we want to save the global variables which are initialized with a defined value.

We have to link the variable addresses in the RAM memory, but we have to save the initial values in the FLASH memory.

In gcc you would do this like this:
 .<region> : {
   ...
 } >RAM AT >FLASH
But this failes in llvm’s linker.
I had some time to figure this out…
* define all the FLASH regions
* set the current address locator to the RAM address space . = ORIGIN(RAM);
And then define the RAM region which values are stored in FLASH memory
. = ORIGIN(RAM);

.<region> : AT(<Flash-location>) {
    ...
 } > RAM

 <marker> = LOADADRESS(.<region>)
Any other way will fail!

So in the end I defined it that way:
. = ORIGIN(RAM);
```
.data : AT(__exidx_end__) {
    _sdata = .;            /* create a global symbol at data start */
    *(.data)              /* .data sections */
    *(.data*)             /* .data* sections */

    . = ALIGN(4);         /* align */
    _edata = .;           /* define a global symbol at data end */
 } > RAM

 _sidata = LOADADDR(.data); /* get the start address of the .data section */
```

As you might expect `*(.data)` are the values. We store them appending to the `__exidx_end__` address in FLASH. The linker will reserve the same space in RAM. Also we define a location variable `_sidata` and copy the address of the .data section to it
We will need to copy the values from FLASH to RAMby Hand in the startup file.
and then follows the so called .bss section with uninitialized variables and a special arm attribute `.ARM.attributes 0 : { *(.ARM.attributes) }`

conclusion

After hours of trial and error I finally got a minimalistic linker file to work with my microcontrollers.

ld.lld might not be in a very mature state at the moment.

But maybe this will be better with LLVM-6.0
    Written on January  8, 2018


STM32Cube Library's

    Source URL: https://hwengineer.github.io/STM32Cube/


STM32Cube Library's

ST distributes a Hal Driver called STM32Cube.

I used this driver also in my projects.

To use it with meson build we just have to make a small change and add some path’s.
inspect Library

first I downloaded the STM32Cube-F3 for my STM32F3Discovery project.
```
├── Documentation
|   ├──...
├── Drivers                   # Folder of interest
|   ├──BSP                    # Abstraction for example projects
|   ├──CMSIS                  # cmsis and core defintions
|   ├──STM32F3xx_HAL_Driver   # hal driver itself
├── _htmlresc
|   ├──...
├── Middlewares
|   ├──...
├── Projects
|   ├──...
├── Utilities
|   ├──...
├── package.xml
├── Release_Notes.html
```
We see here the folder structure of the STM32Cube-F3 Library (V1.9.0)

The interesting part is in the Drivers folder. In there we have the CMSIS Folder and the STM32F3xx_HAL_Driver
```
CMSIS
├── Device
|   ├── ST
|       ├── STM32F3xx
|           ├── Include           # header files of specific devices
|           ├── Source
|               ├── Templates
|                   ├── gcc       # startup files
|            Release_Notes.html
├── Documentation
├── DSP_Lib
├── Include
├── Lib
├── RTOS
```
In the CMSIS Folder are files which defines the Cortex-M Core.

In the CMSIS/Device/ST/STM32F3xx/Source/Template/gcc we find the startup files from ST.

All startup files in my repo are adjusted copy’s from here.

We have to include all the include folders and all C files in the Source directory for a minimal compilation.

If you do not use the DSP Library or an RTOS you don’t have to link these folders.

```
STM32F3xx_HAL_Driver
├── Include      # hal driver header files
|   ├── Legacy   # hal driver header files
├── Source       # hal driver source files
```

As you might expect. Here is the hal driver.

In the Source and Include folder we have some template files. We don’t have to compile these of course.

But there is one file : Include/stm32f3xx_hal_conf_template.h

This file specifies which hal drivers are getting loaded and configures some compiler flags if they are not defined by the user.
I copied the Include/stm32f3xx_hal_conf_template.h template to the Drivers folder and renamed it to stm32f3xx_hal_conf.h.

With this change other files from the HAL-Driver will find this configuration file.

In its initial state it enables all libraries. Thats totally okay. We use the linker to get rid of unused code later! And because meson build together with ninja is very efficient, it will only compile it once and will never unnecessarily recompile it again.
meson.build

I also placed an meson.build file in the root folder of this library.

Later we can call the library with just one line in the meson.build script and it will load all necessary stuff!
In the STM32Cube-F3-meson/meson.build file I defined two variables
stm32cube_incdirs = []
stm32cube_srcs    = []
we will use this arguments later in the root meson.build file to create our executable with this hal-driver.
In stm32cube_incdirs we save all folders which contain header files

In stm32cube_srcs and here of course all source files.
Because its really annoying to get every C-File path I wrote a python script to search all c file.
At the beginning of the meson.build i also defined two flags which are used by the hal-driver
c_args += '-DUSE_HAL_DRIVER'
c_args += '-DUSE_LEGACY'
thats all it needs.
usage

In the project root meson.build we just have to call the library

```
# add STM library
subdir('STM32Cube-F3-meson')
```

and use the path variables in the executable command

```
main = executable(
            'main.elf',
            [srcs, stm32cube_srcs, 'main.c', startupfile] ,
            c_args              : [c_args ],
            link_args           : [link_args, '-Wl,--gc-sections'],
            dependencies        : link_deps,
            include_directories : [incdirs, stm32cube_incdirs] )
    Written on January  9, 2018
```


Test Driven Development

One of my (unwritten) goals was to enable a Test-Driven-Development work-flow.
Qemu

A way to implement this, is to let meson call a simulator.
And of course there is already a cpu simulator here which can emulate a cortex-m microcontroller!
It’s called qemu
it is also in the ubuntu repositories:
```
sudo apt-get install qemu-system-arm
```

usage

we can use qemu the following way:
qemu-system-arm -kernel <path/file.elf> -machine lm3s811evb -cpu cortex-m3 -semihosting -nographic
with the kernel parameter we define the exectable to run. With machine we tell qemu to emulate a specific hardware. In this case the development board of a TI Sitara microcontroller (cortex-m3). With cpu we define of course the cpu architecture. And with the semihosting we can use ARM-Semihosting commands to signaling a successful or failed test. The nografic option is needed because our emulated system does not have a standard visual output.
We can also use this machine / cpu combo for cortec-m0 / 1 / 0+ controllers, because the cortex-m3 is a superset of the other cortex architectures. For the cortex-m4 / m7 i didn’t found a suitable combo (qemu-syste-arm V2.5)
arm-semihosting

Of course I first needed arm-semihosting to work.
I implemented 3 functions in assembler for this.
I began with an inline assembly code. But the compiler optimized me a single command inside, so that Register R1 was overwritten. With an handwritten assembly code this didnt happend again.
I don’t want to explain arm-semihosting here and just add a link to some ressources and my assembly / header files.
helloWorld Test

We can now write TDD Test files and let them simulate them with qemu to find runtime errors or to implement integration tests to find regression bugs.
First we write a simple helloWorld test:

```
/*********************************************************
* helloWorld.c
*
* A positive test with the intention to test the testing-environment
* Together with an always false test (like mustFail.c) we can check
* if the testing env is working properly
*********************************************************/

#include <stdint.h>

#define DEBUG // to use ARM_Semihosting only in testing
#include "arm_semi.h"

int  main(void);

int main(void) {

  // use semihosting to write a debug message
  arm_semi_syswrite0("HelloWorld\n");

  // end test with semihosting command ReportException with the rigth Exit Code
  arm_semi_angel_swireason_reportexception(ADP_Stopped_ApplicationExit); /*Exit, no Error*/

  HAL_Init(); // strange linker bug. it needs to be called so ld.lld does not segfault.
              // needs further investigation...

}
```

At first we see the include of the arm_semi.h to use arm-semihosting.
the function arm_semi_syswrite0 writes a string to stdout.
And with the arm_semi_angel_swireason_reportexception(ADP_Stopped_ApplicationExit) we say to qemu to end the test with a success every other value inside the reportexception function does return a failure.
At the moment I have a string bug with the llvm linker.
If I delete the HAL_Init() function, ld.lld will segfault
And I have no idea at the moment why thats happening
conclusion

We can now use qemu to implement a TDD work-flow and simulate the cortex-m0 to cortex-m3 series
    Written on January 16, 2018
