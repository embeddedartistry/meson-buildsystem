native_compiler_id = meson.get_compiler('c', native : true).get_id()

if meson.is_cross_build()
	host_compiler_id = meson.get_compiler('c', native : false).get_id()
endif

if meson.is_cross_build()
	if host_compiler_id == 'clang'
		subdir('clang')
	elif host_compiler_id == 'gcc'
		subdir('gcc')
	endif
else
	if native_compiler_id == 'clang'
		subdir('clang')
	elif native_compiler_id == 'gcc'
		subdir('gcc')
	endif
endif
