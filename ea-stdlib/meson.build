# Configures Meson to use the EA Standard Library

# TODO: is this ever valid? -nostdinc
stdlib_compiler_flags = [
	'-fno-builtin',
	'-nodefaultlibs',
	'-nostdinc++'
]

# TODO: is this ever valid? 	'-nostdlib++',
stdlib_link_flags = [
	'-nostdlib',
	'-nodefaultlibs',
	'-nostartfiles'
]

if meson.is_cross_build()
	stdlib_compiler_flags += '-fPIC'
endif

# if we are on OSX, we can't link as '-static'...

compiler_id = meson.get_compiler('cpp').get_id()

if compiler_id == 'clang'
	# Disabled these - not working?
	#stdlib_compiler_flags += ['-fno-address-santizer', '-fno-memsafety']

	if(host_machine.system() == 'darwin')

		# The following flags are required to link and run an app on OSX
		stdlib_link_flags += ['-prebind', '-all_load', '-lsystem']

	endif

elif compiler_id == 'gcc'

	stdlib_compiler_flags += ['-fno-stack-protector-all']

endif

# TODO: when are these needed?
# TODO: Can we define a stack protector?
stdlib_compiler_flags += ['-fno-stack-protector', '-freestanding']
