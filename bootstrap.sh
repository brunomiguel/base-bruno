#! /bin/bash -e

groups=(
  "base-devel"
)

echo -e "Adding userrepository to /etc/pacman.conf..."
echo -e '\n[userrepository]\nServer = https://userrepository.eu\nSigLevel = Optional TrustAll' | sudo tee -a /etc/pacman.conf
echo "Done."
sleep 2s

echo -e "Userrepository enabled. Now refreshing mirrors and installing any updates available..."
sudo pacman -Syyuv --noconfirm
echo "Done."
sleep 2s

echo -e "Installing base groups..."
sudo pacman -Syuv ${groups[@]}
echo "Done."
sleep 2s

echo -e "Building and installing metapackage..."
makepkg -C -c -d -f -i
echo "Done."
sleep 2s

echo -e "All done.\n"
