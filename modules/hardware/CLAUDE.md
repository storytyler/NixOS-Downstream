# Hardware Modules

This directory contains configurations for hardware components and peripherals. Hardware modules are conditionally enabled based on system variables and detected hardware.

## Module Categories

- **drives/** - Storage devices and filesystem configuration
- **video/** - Graphics drivers and GPU configuration

## Hardware Selection Logic

Hardware modules are activated based on variables in `hosts/Default/variables.nix`:

```nix
# Example hardware variables
variables = {
  gpu = "nvidia";    # Options: "nvidia", "amdgpu", "intel"
  # Additional hardware settings as needed
}
```

## Video Configuration

### GPU Drivers
The video module supports multiple GPU configurations:

#### NVIDIA Graphics
- Proprietary NVIDIA drivers
- CUDA support for computation
- Optimus support for laptops
- Hardware acceleration

#### AMD Graphics
- Open-source AMDGPU drivers
- Vulkan and OpenGL support
- Hardware video acceleration
- Power management

#### Intel Graphics
- Integrated Intel graphics
- Hardware acceleration
- Power-efficient operation
- Good compatibility

### Display Configuration
- Multiple monitor support
- Resolution and refresh rate settings
- Display port configuration
- Color management

## Storage Configuration

### Drive Management
- SSD optimization
- HDD configuration
- External storage devices
- RAID configurations

### Filesystem Support
- Native filesystem support (ext4, btrfs, xfs)
- Windows filesystem support (NTFS)
- Network filesystems (NFS, Samba)
- Special filesystems (ZFS if needed)

### Performance Optimization
- TRIM support for SSDs
- I/O scheduler configuration
- Memory management
- Cache optimization

## Configuration Patterns

### Conditional GPU Support
```nix
# Example GPU configuration
config = lib.mkIf (config.variables.gpu == "nvidia") {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    # Additional NVIDIA settings
  };
};
```

### Storage Configuration
```nix
# Example storage setup
services.btrfs = {
  enable = true;
  # Btrfs-specific settings
};

# SSD optimization
services.fstrim.enable = lib.mkIf config.useSSD true;
```

## Hardware Detection

### Automatic Detection
- Hardware is detected during system boot
- Kernel modules loaded automatically
- Device-specific optimizations applied

### Manual Configuration
- Override automatic detection if needed
- Custom kernel parameters
- Specific hardware tweaks

## Integration Points

### With Desktop Environment
- Display server configuration (X11/Wayland)
- Display manager integration
- GPU acceleration for desktops
- Monitor configuration

### With Applications
- Hardware acceleration for browsers
- GPU computation for scientific software
- Gaming performance optimization
- Video encoding/decoding acceleration

### With System Services
- Power management
- Thermal management
- Fan control
- Battery management (laptops)

## Common Hardware Features

### Graphics Features
- Hardware video acceleration
- Multi-monitor support
- GPU switching (laptops)
- OpenGL/Vulkan support

### Storage Features
- Fast boot times
- Filesystem optimization
- Backup and recovery tools
- Disk health monitoring

### Peripheral Support
- USB device management
- Audio device configuration
- Network adapter setup
- Printer and scanner support

## Performance Optimization

### Graphics Performance
- Proper driver installation
- Hardware acceleration enabled
- Display settings optimized
- GPU power management

### Storage Performance
- SSD configuration
- Filesystem choice optimization
- Memory management
- I/O scheduling

## Troubleshooting

### Graphics Issues
1. **No Display** - Check GPU drivers and display manager
2. **Poor Performance** - Verify hardware acceleration
3. **Multi-monitor Problems** - Check display configuration
4. **Driver Crashes** - Update drivers or try open-source alternatives

### Storage Issues
1. **Slow Performance** - Check TRIM settings and filesystem
2. **Mount Problems** - Verify filesystem support
3. **External Devices** - Check USB/storage drivers
4. **SSD Issues** - Monitor drive health and firmware

### General Hardware
1. **Device Not Recognized** - Check kernel module loading
2. **Performance Problems** - Monitor system resources
3. **Power Issues** - Check power management settings
4. **Overheating** - Verify thermal management

## Adding New Hardware Support

1. Create configuration file for hardware component
2. Add necessary kernel modules
3. Configure device-specific settings
4. Add conditional loading based on variables
5. Test with target hardware
6. Update documentation

## Best Practices

1. **Conditional Loading** - Only load needed hardware modules
2. **Fallback Options** - Provide alternative configurations
3. **Performance First** - Optimize for hardware capabilities
4. **Stability** - Use tested driver configurations
5. **Documentation** - Include hardware-specific setup notes

## Testing Changes

After modifying hardware configurations:
1. Rebuild system: `sudo nixos-rebuild switch --flake ".#Default"`
2. Test hardware functionality
3. Verify performance improvements
4. Check system logs for errors
5. Test all affected hardware components

## Dependencies

Hardware modules depend on:
- Kernel configuration and modules
- Firmware packages
- System services configuration
- Desktop environment integration
- Application hardware requirements

## Security Considerations

- Hardware access permissions
- Firmware update security
- Device isolation
- Secure boot compatibility
- Hardware vulnerability patches