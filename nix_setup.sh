echo "Nix setup starting ------------------\n"

echo "Copying files -----------------------\n"
sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo cp ./hm.nix /etc/nixos/hm.nix

sudo mkdir /etc/nixos/nvim
sudo cp ./nvim/init.lua /etc/nixos/nvim/init.lua

echo "Running rebuild ---------------------\n"
sudo nixos-rebuild switch