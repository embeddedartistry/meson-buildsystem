compiler_native_args = []
compiler_target_args = []
cpp_compiler_native_args = []
cpp_compiler_target_args = []
linker_native_args = []
linker_target_args = []

###############
# Clang Flags #
###############

clang_warnings = [
	'-Wall',
	'-Wextra',
	#'-Weverything'
]

# We don't support C++98
# We don't mind padding being added
clang_warnings_disable = [
	'-Wno-c++98-compat',
	'-Wno-c++98-compat-pedantic',
	'-Wno-padded',
	# causes warnings if you use static values
	'-Wno-exit-time-destructors',
	'-Wno-global-constructors',
	'-Wno-covered-switch-default',
	# We call main() from our boot sequencer
	'-Wno-main',
]

clang_compiler_flags = [
	'-fcolor-diagnostics'
]

clang_compiler_cpp_flags = []

# If we are building native applications with clang, we don't want these flags
if meson.is_cross_build() and target_compiler_id == 'clang'
	clang_compiler_flags += [
		# Baremetal programs will not need to call exit() or exit-time static destructors
		'-fPIC',
		'-ffreestanding',
	]

	clang_compiler_cpp_flags += [
		'-fno-use-cxa-atexit',
	]
endif

clang_compiler_debug_flags = [
	# Dump the layouts of all vtables that will be emitted in a translation unit
	'-fdump-vtable-layouts',
]

clang_compiler_runtime_debug_flags = [
	# Enable runtime bounds checks
	'-fbounds-checking',
	# Generate runtime checks for undefined behavior
	'-fcatch-undefined-behavior',
]

clang_compiler_optimization_flags = [
	# Place each functon in its own section (ELF Only)
	'-ffunction-sections',
	# Place each data in its own section (ELF Only)
	'-fdata-sections',
	#'-fshort-enums',
]

clang_linker_flags = [
]

clang_linker_optimization_flags = [
	'-Wl,-dead_strip',
]

compiler_warnings = [
	clang_warnings,
	clang_warnings_disable,
]

compiler_args = [
	clang_compiler_flags
]

cpp_compiler_args = [
	clang_compiler_cpp_flags
]

cpp_compiler_warnings = []

linker_args = [
	clang_linker_flags,
]
