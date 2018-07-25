# Configures Meson to use the EA Standard Library

stdlib_compiler_flags = [
	'-fno-builtin',
	'-nodefaultlibs',
]

stdlib_link_flags = [
	'-nodefaultlibs',
	'-nostartfiles'
]

if meson.is_cross_build()
	compiler_id = meson.get_compiler('c', native : false).get_id()
else
	compiler_id = meson.get_compiler('c', native : true).get_id()
endif

# TODO: Can I re-enable these??
stdlib_compiler_flags += ['-fno-stack-protector']
if compiler_id == 'clang'
	#stdlib_compiler_flags += ['-fno-address-santizer', '-fno-memsafety']
elif compiler_id == 'gcc'
	stdlib_compiler_flags += ['-fno-stack-protector-all']
endif
