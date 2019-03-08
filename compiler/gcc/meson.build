#############
# GCC Flags #
#############

gcc_warnings = [
	'-Wall',
	'-Wextra',
	'-pedantic',
	'-Wconversion',
	'-Wfloat-equal',
	'-Wlogical-op',
	'-Wundef',
	'-Wredundant-decls',
	'-Wshadow',
	'-Wstrict-overflow=5',
	'-Wwrite-strings',
	'-Wpointer-arith',
	'-Wcast-qual',
	'-Wformat=2',
	'-Wswitch-default',
	'-Wmissing-include-dirs',
	'-Wcast-align',
	'-Wswitch-enum',
	'-Wsign-conversion',
	'-Wdisabled-optimization',
	'-Winline',
	'-Winvalid-pch',
	'-Wmissing-declarations',
	'-Wno-unknown-pragmas',

	# GCC V5.0 and above
	'-Wdouble-promotion',
	'-Wtrampolines',
	'-Wvector-operation-performance',
]

gcc_cpp_warnings = [
	'-Weffc++',
	'-Wold-style-cast',
	'-Wnon-virtual-dtor',
	'-Wctor-dtor-privacy',
	'-Woverloaded-virtual',
	'-Wnoexcept',
	'-Wstrict-null-sentinel',
	# GCC V5.0 and above
	'-Wuseless-cast',
	'-Wzero-as-null-pointer-constant',
]

gcc_version = meson.get_compiler('cpp').version()

if gcc_version.version_compare('>=6.0')
	gcc_warnings += [
		# GCC V6.0 and above
		'-Wshift-overflow=2',
		'-Wnull-dereference',
		'-Wduplicated-cond',
	]
endif

if gcc_version.version_compare('>=7.0')
	gcc_warnings += [
		# GCC V7.0 and above
		'-Walloc-zero',
		'-Walloca',
		'-Wduplicated-branches',
	]
endif

if gcc_version.version_compare('>=8.0')
	gcc_warnings += [
		# GCC V8.0 and above
		'-Wcast-align=strict',
	]
endif

gcc_warnings_disable = [

]

gcc_compiler_optimization_flags = [
	'-fdevirtualize',
	'-ffunction-sections',
]

gcc_linker_flags = [
	'-e_start',
]

gcc_linker_optimization_flags = [

]

# Not enabled:
# 	'-fvisibility=hidden'
#	'-fstrict-aliasing'
gcc_compiler_flags = [
	'-fdiagnostics-show-option',
]

compiler_args = [
	gcc_warnings,
	gcc_warnings_disable,
	gcc_compiler_flags
]

cpp_compiler_args = [
	gcc_cpp_warnings,
]

linker_args = [
	gcc_linker_flags,
]
