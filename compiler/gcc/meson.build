compiler_native_args = []
compiler_target_args = []
cpp_compiler_native_args = []
cpp_compiler_target_args = []
linker_native_args = []
linker_target_args = []

#############
# GCC Flags #
#############

gcc_warnings = [
	'-Wall',
	'-Wextra',
	'-Wconversion',
	'-Wfloat-equal',
	'-Wlogical-op',
	'-Wundef',
	'-Wredundant-decls',
	'-Wshadow',
	'-Wstrict-overflow=5',
	'-Wwrite-strings',
	'-Wpointer-arith',
	'-Wcast-qual',
	'-Wformat=2',
	'-Wswitch-default',
	'-Wmissing-include-dirs',
	'-Wcast-align',
	'-Wswitch-enum',
	'-Wsign-conversion',
	'-Wdisabled-optimization',
	'-Winline',
	'-Winvalid-pch',
	'-Wmissing-declarations',
	'-Wno-unknown-pragmas',

	# GCC V5.0 and above
	'-Wdouble-promotion',
	'-Wtrampolines',
	'-Wvector-operation-performance',
]

gcc_cpp_warnings = [
	'-Weffc++',
	'-Wold-style-cast',
	'-Wnon-virtual-dtor',
	'-Wctor-dtor-privacy',
	'-Woverloaded-virtual',
	'-Wnoexcept',
	'-Wstrict-null-sentinel',
	# GCC V5.0 and above
	'-Wuseless-cast',
	'-Wzero-as-null-pointer-constant',
]

gcc_version = meson.get_compiler('cpp').version()

if gcc_version.version_compare('>=6.0')
	gcc_warnings += [
		'-Wshift-overflow=2',
		'-Wnull-dereference',
		'-Wduplicated-cond',
	]
endif

if gcc_version.version_compare('>=7.0')
	gcc_warnings += [
		'-Walloc-zero',
		'-Walloca',
		'-Wduplicated-branches',
	]
endif

if gcc_version.version_compare('>=8.0')
	gcc_warnings += [
		'-Wcast-align=strict',
	]

	gcc_cpp_warnings += [
		'-Wextra-semi',
	]
endif

gcc_warnings_disable = [

]

gcc_compiler_optimization_flags = [
	# Attempt to convert calls to virtual functions to direct calls
	'-fdevirtualize',
	#'-fdevirtualize-speculatively',
	# Place each functon in its own section (ELF Only)
	'-ffunction-sections',
	# Place each data in its own section (ELF Only)
	'-fdata-sections',
	#'-fshort-enums',
	#'-flto',
	# The difference between fat and non-fat object files is that fat object files contains
	# both intermediate language as well as the normally compiled code.
	# At linktime, if you invoke compiler without -flto, fat objects will be handled as normal
	# object files (and LTO information discarded), while slim objects will invoke LTO optimizers
	# because there is no way to handle them without it.
	# If you both compile and link with -flto, both fat and slim objects ought to give you the
	# same binary, just slim objects will be smaller and faster to compile, because you will avoid
	# the redundant code generation.
	#'-ffat-lto-objects',
]

gcc_linker_flags = [
]

gcc_linker_optimization_flags = [
	#'-flto',
	#'-fuse-linker-plugin'
]

gcc_compiler_flags = [
	# Some gcc builds include C++ headers with an extern C around them... causing errors.
	'-DNO_IMPLICIT_EXTERN_C=1',
	'-fdiagnostics-show-option',
]

gcc_compiler_cpp_flags = []

# If we are building native applications with gcc, we don't want these flags
if meson.is_cross_build() and target_compiler_id == 'gcc'
	# Baremetal programs will not need to call exit() or exit-time static destructors
	gcc_compiler_flags += [
		# Baremetal programs will not need to call exit() or exit-time static destructors
		'-fPIC',
		'-ffreestanding',
	]

	gcc_compiler_cpp_flags += [
		'-fno-use-cxa-atexit',
	]
endif

################################
# Decide whether to use no-pie #
################################

if build_machine.system() == 'linux'
	linker_native_args += [
		'-no-pie',
	]
endif

if host_machine.system() == 'linux'
	linker_target_args += [
		'-no-pie',
	]
endif

#######################################
# Decide on dead_strip vs gc-sections #
#######################################

if build_machine.system() == 'darwin'
	linker_native_args += [
		'-Wl,-dead_strip'
	]
else
	linker_native_args += [
		'-Wl,--gc-sections'
	]
endif

if host_machine.system() == 'darwin' or host_machine.system() == 'compiler-check'
	linker_target_args += [
		'-Wl,-dead_strip'
	]
else
	linker_target_args += [
		'-Wl,--gc-sections'
	]
endif

compiler_args = [
	gcc_compiler_flags,
	gcc_compiler_optimization_flags
]

compiler_warnings = [
	gcc_warnings,
	gcc_warnings_disable,
]

cpp_compiler_args = [
	gcc_compiler_cpp_flags
]

cpp_compiler_warnings = [
	gcc_cpp_warnings
]

linker_args = [
	gcc_linker_flags,
	gcc_linker_optimization_flags
]
