# Confirm architecture and set include paths based on that

# TODO: ARM support

if meson.is_cross_build()
	architecture = host_machine.cpu_family()
	# TODO: parse CPU for ARM -> cortex-m4, etc.
else
	architecture = build_machine.cpu_family()
	# CPU not currently needed - x86 or x86_64 handled correctly
endif
