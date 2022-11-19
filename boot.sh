base_name=$1
image_name=${base_name%.*}

if [ $# != 1 ]; then
    echo ERROR: wrong argment.
    exit 1
fi

qemu-img create -f raw ${image_name}.img 200M
mkfs.fat -n 'OS' -s 2 -f 2 -R 32 -F 32 ${image_name}.img
hdiutil attach -mountpoint mnt ${image_name}.img
mkdir -p mnt/EFI/BOOT
cp BOOTX64.EFI mnt/EFI/BOOT/BOOTX64.EFI
hdiutil detach mnt
qemu-system-x86_64 -drive if=pflash,file=OVMF_CODE.fd -drive if=pflash,file=OVMF_VARS.fd -hda ${image_name}.img

