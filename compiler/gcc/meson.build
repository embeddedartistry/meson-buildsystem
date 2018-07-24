#############
# GCC Flags #
#############

gcc_warnings = [
	'-Wall',
	'-Wextra',
	'-Weffc++',
	'-pedantic',
	'-pedantic-errors',
	'-Wconversion',
	'-Wold-style-cast',
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
	'-Wnon-virtual-dtor',
	'-Wctor-dtor-privacy',
	'-Wsign-conversion',
	'-Wdisabled-optimization',
	'-Winline',
	'-Winvalid-pch',
	'-Wmissing-declarations',
	'-Woverloaded-virtual',
	'-Wnoexcept',

	# GCC V5.0 and above
	'-Wdouble-promotion',
	'-Wtrampolines',
	'-Wzero-as-null-pointer-constant',
	'-Wuseless-cast',
	'-Wvector-operation-performance',
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
