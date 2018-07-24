
###############
# Clang Flags #
###############

clang_warnings = [
	'-pedantic',
	'-pedantic-errors',
	'-Weverything'
]
# Is this needed? '-Qunused-arguments'

# We don't support C++98
# We don't mind padding being added
clang_warnings_disable = [
	'-Wno-c++98-compat',
	'-Wno-c++98-compat-pedantic',
	'-Wno-padded'
]

# Not enabled:
# 	'-fvisibility=hidden'
#	'-fstrict-aliasing'
clang_compiler_flags = [
	'-fcolor-diagnostics'
]

compiler_args = [
	clang_warnings,
	clang_warnings_disable,
	clang_compiler_flags
]
