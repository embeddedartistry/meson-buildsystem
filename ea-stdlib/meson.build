# Configures Meson to use the EA Standard Library

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

compiler_id = meson.get_compiler('cpp').get_id()

stdlib_compiler_flags += ['-fno-stack-protector']
if compiler_id == 'clang'
	#stdlib_compiler_flags += ['-fno-address-santizer', '-fno-memsafety']
elif compiler_id == 'gcc'
	stdlib_compiler_flags += ['-fno-stack-protector-all']
endif
