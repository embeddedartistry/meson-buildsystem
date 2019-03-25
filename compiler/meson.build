native_compiler_id = meson.get_compiler('c', native : true).get_id()
target_compiler_id = meson.get_compiler('c', native : false).get_id()

message('Supplying default flags for native compiler: ' + native_compiler_id)
subdir(native_compiler_id)
native_compiler_args = compiler_args
native_cpp_compiler_args = cpp_compiler_args
native_linker_args = linker_args

if meson.is_cross_build()

	if target_compiler_id == native_compiler_id
		message('Using same flags for target and native compiler')
		target_compiler_args = native_compiler_args
		target_cpp_compiler_args = native_cpp_compiler_args
		target_linker_args = native_linker_args
	else
		message('Supplying default flags for target compiler: ' + target_compiler_id)
		subdir(target_compiler_id)
		target_compiler_args = compiler_args
		target_cpp_compiler_args = cpp_compiler_args
		target_linker_args = linker_args
	endif

else
	message('Since this is not a cross build, target_*_args will match native_*_args')
	target_compiler_args = compiler_args
	target_cpp_compiler_args = cpp_compiler_args
	target_linker_args = linker_args

endif
