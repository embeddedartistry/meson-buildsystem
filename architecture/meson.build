# Confirm architecture and set include paths based on that

# TODO: ARM support

if meson.is_cross_build()
	target_architecture = host_machine.cpu_family()
	host_architecture = build_machine.cpu_family()
	# TODO: parse CPU for ARM -> cortex-m4, etc.
else
	target_architecture = build_machine.cpu_family()
	host_architecture = build_machine.cpu_family()
	# CPU not currently needed - x86 or x86_64 handled correctly
endif
