parted -s /dev/nvme0n1 -- mklabel gpt
parted -s /dev/nvme0n1 -- mkpart root ext4 512MB -8GB
parted -s /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100%
parted -s /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted -s /dev/nvme0n1 -- set 3 esp on
mkfs.ext4 -L nixos /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3
mount /dev/nvme0n1p1 /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/nvme0n1p3 /mnt/boot
swapon /dev/nvme0n1p2
cp -r /root/.dotfiles/nixos/* /mnt/etc/nixos