# Configures Meson to use the EA Standard Library
#
# NOTE: if we are on OSX, we can't link as '-static'...

# TODO: is this ever valid? -nostdinc
stdlib_compiler_flags = [
	'-fno-builtin',
	'-nodefaultlibs',
	#'-nostdinc',

	# TODO: Can we define a stack protector?
	'-fno-stack-protector',
]

cpp_stdlib_compiler_flags = [
	# Disable standard #include directories for the C++ standard library
	# This is analagous to -nostlib++
	'-nostdinc++',
	# C++ STL needs GNU functions. Not-so-standard, are we?
	'-D_GNU_SOURCE',
]

stdlib_link_flags = [
	# Do not use the standard system startup files or libraries when linking.
	# No startup files and only the libraries you specify are passed to the
	# linker, and options specifying linkage of the system libraries, such as
	# -static-libgcc or -shared-libgcc, are ignored.
	'-nostdlib',

	# Do not use the standard system libraries when linking.
	# Only the libraries you specify are passed to the linker, and options
	# specifying linkage of the system libraries, such as -static-libgcc or
	# -shared-libgcc, are ignored. The standard startup files are used normally,
	# unless -nostartfiles is used.
	'-nodefaultlibs',

	# Do not use the standard system startup files when linking
	'-nostartfiles',
]

native_stdlib_compiler_flags = []
native_stdlib_link_flags = []

##
# Check the target machine parameters, to set special flags
##

target_compiler_id = meson.get_compiler('cpp').get_id()
if target_compiler_id == 'clang'

	#  Disable builtin #include directories
	stdlib_compiler_flags += [
		# We now get an unused argument warning with clang...
		#'-nobuiltininc'
	]

	if(host_machine.system() == 'darwin')

		# The following flags are required to link and run an app on OSX
		# See note below
		# TODO: remove 'lsystem' here
		stdlib_link_flags += ['-all_load', '-lsystem']
	endif

endif

##
# Check the host machine parameters, which will be used to build
# tooling and programs for the build machine in a cross-compilation scenari
##

native_compiler_id = meson.get_compiler('cpp', native: true).get_id()
if native_compiler_id == 'clang'

	#  Disable builtin #include directories
	native_stdlib_compiler_flags += [
		# We now get an unused argument warning with clang...
		# '-nobuiltininc'
	]

	if(build_machine.system() == 'darwin')

		# The following flags are required to link and run an app on OSX
		# See note below
		# TODO: remove 'lsystem' here
		native_stdlib_link_flags += ['-all_load', '-lsystem']
	endif

endif


##
# Note on all_load flags for Apple clang
##
# IMPORTANT: For 64-bit and iPhone OS applications,
# there is a linker bug that prevents -ObjC from loading objects files from
# static libraries that contain only categories and no classes. The workaround
# is to use the -all_load or -force_load flags. -all_load forces the linker to
#load all object files from every archive it sees, even those without Objective-C
# code. -force_load is available in Xcode 3.2 and later. It allows finer grain
# control of archive loading. Each -force_load option must be followed by a path
# to an archive, and every object file in that archive will be loaded.
