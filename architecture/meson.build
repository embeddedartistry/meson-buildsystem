# Confirm architecture and set include paths based on that

# CPU not currently needed - we are just using the family, and x86 vs x86_64 is handled correctly.

if meson.is_cross_build()
	target_architecture = host_machine.cpu_family()
	native_architecture = build_machine.cpu_family()
else
	target_architecture = build_machine.cpu_family()
	native_architecture = build_machine.cpu_family()
endif
