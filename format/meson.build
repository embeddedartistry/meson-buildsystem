###############################################
# Automated Code Formatting with Clang-Format #
###############################################
# By including this module in your build, you will gain access to clang-format
# targets, which run clang-format on your project using the default settings
# which are expected to be in .clang-format file(s) in your source tree.
#
# By default, clang-format will run on all .c/.h/.cpp/.hpp files in the `src` and `test`
# directories in the source root of the project. If you need to override the default
# settings, you can do so by defining a variable called clangformat_args. This variable should
# be an array of strings, including options that will be passed to the `format.sh` script,
# as well as files and folders to be checked by clang-format.
#
# If you want to use the default settings and simply want to add subdirectories to exclude from
# formatting, you can define a variable called `clangformat_excludes`. This variable should be
# a string, which is a comma-separated list of directories to exclude from formatting. The
# -e argument will be automatically supplied for you.
#
# A list of options can be found below. For more information, please see the documentation
# in format.sh
clangformat_default_args = [
	# Optional exclude directories (separated by commas)
	# '-e', 'src/external',
	# Directories to format files in
	meson.source_root() / 'src,' + meson.source_root() / 'test',
	# File types to include in formatting (separated by commas)
	'*.c,*.h,*.cpp,*.hpp',
]

clangformat_args = get_variable('clangformat_args', clangformat_default_args)
clangformat_excludes = get_variable('clangformat_excludes', [])

# Why do we require a string to be used, but default to an empty list?
# If we defaulted to an empty string value, this would be passed to the shell script
# and break processing of positional arguments. If we pass an empty list to the command,
# nothing will happen. Since both string and array objects have a `length()` parameter,
# we can use this conditional logic safely.
if clangformat_excludes.length() != 0
	clangformat_excludes = ['-e', clangformat_excludes]
endif

# Clang-format run target will be unavailable if the program isn't found
clangformat = find_program('clang-format', required: false, disabler: true)

# If you want to implement a custom clang-format target, you can reference
# This files object to gain access to the script
clangformat_script = files('format.sh')

if clangformat.found()
	run_target('format',
		command: [
			clangformat_script,
			# Optional excludes
			clangformat_excludes,
			# Supply arguments
			clangformat_args
		]
	)

	run_target('format-patch',
		command: [
			clangformat_script,
			# Enable patch file,
			'-p',
			# Optional excludes
			clangformat_excludes,
			# Supply arguments
			clangformat_args
		]
	)
endif
