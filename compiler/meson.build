native_compiler_id = meson.get_compiler('c', native : true).get_id()

subdir(native_compiler_id)
native_compiler_args = compiler_args
native_cpp_compiler_args = cpp_compiler_args
native_linker_args = linker_args

if meson.is_cross_build()

	target_compiler_id = meson.get_compiler('c', native : false).get_id()

	if target_compiler_id == native_compiler_id
		target_compiler_args = native_compiler_args
		target_cpp_compiler_args = native_cpp_compiler_args
		target_linker_args = native_linker_args
	else
		subdir(target_compiler_id)
		target_compiler_args = compiler_args
		target_cpp_compiler_args = cpp_compiler_args
		target_linker_args = linker_args
	endif

else

	target_compiler_args = compiler_args
	target_cpp_compiler_args = cpp_compiler_args
	target_linker_args = linker_args

endif
