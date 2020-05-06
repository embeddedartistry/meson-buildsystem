#############################
# Cppcheck Analysis Support #
#############################
# By including this module in your build, you will gain access to cppcheck and
# cppcheck-xml targets.
#
# By default, cppcheck will be run with `--enable=style` on the `src` and `test`
# directories in the source root of the project. If you need to override the default
# settings, you can do so by defining a variable called cppcheck_args. This variable should
# be an array of strings, including options that will be passed to the `cppcheck.sh` script,
# as well as files and folders to be checked by cppcheck.
#
# A list of options can be found below. For more information, please see the documentation
# in cppcheck.sh
cppcheck_default_args = [
	# include dir
	# '-i', 'include',
	# files to exclude
	# '-x', 'path/to/exclude'
	# custom rule riles
	# '-r', 'path/to/rule1.xml,path/to/rule2.xml'
	# override checks
	# '-c', 'style,whateverelse'
	# Files/folders to check
	meson.source_root() / 'src',
	meson.source_root() / 'test',
]

cppcheck_args = get_variable('cppcheck_args', cppcheck_default_args)

# Cppcheck run targets will be unavailable if the program isn't found
cppcheck = find_program('cppcheck', required: false, disabler: true)

# If you want to implement a custom cppcheck target, you can reference
# This files object to gain access to the script
cppcheck_script = files('cppcheck.sh')

if cppcheck.found()
	run_target('cppcheck',
		command: [
			cppcheck_script,
			# Supply Arguments
			cppcheck_args
		]
	)

	run_target('cppcheck-xml',
		command: [
			cppcheck_script,
			# Enable XML output
			'-x',
			# Supply Arguments
			cppcheck_args
		],
	)
endif
