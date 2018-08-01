
###############
# Clang Flags #
###############

clang_warnings = [
	'-pedantic',
	'-Weverything'
]
# Is this needed? '-Qunused-arguments'

# We don't support C++98
# We don't mind padding being added
clang_warnings_disable = [
	'-Wno-c++98-compat',
	'-Wno-c++98-compat-pedantic',
	'-Wno-padded'
	# causes warnings if you use static values
	#'-Wno-global-constructors',
	# causes warnings about main and statics
	#'-Wno-exit-time-destructors',
	# causes warnings from conditional macros that check an undefined value (e.g. #ifdef _WIN32 in linux build)
	#'-Wno-unused-macros',
	# similar to above, but complains about their lack of definition
	#'-Wno-undef',
]

# Not enabled:
# 	'-fvisibility=hidden'
#	'-fstrict-aliasing'
clang_compiler_flags = [
	'-fcolor-diagnostics'
]

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
	'-ffunction-sections',
]

clang_linker_optimization_flags = [
	# Place each functon in its own section (ELF Only)
	'-ffunction-sections',
	# Place each data in its own section (ELF Only)
	'-fdata-sections',
]

compiler_args = [
	clang_warnings,
	clang_warnings_disable,
	clang_compiler_flags
]
