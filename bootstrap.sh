#! /bin/bash -e

groups=(
  "base-devel"
)

userrepository() {
	read -p "Continue adding userrepository repo (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
		echo -e "Adding userrepository to /etc/pacman.conf..."
		echo -e '\n[userrepository]\nServer = https://userrepository.eu\nSigLevel = Optional TrustAll' | sudo tee -a pacman.conf
		echo "Done.\n"
		sleep 2s
	else
		echo -e "Skipped an essential step. Aborting..."
		exit 0
	fi
}

refresh() {
	echo -e "Userrepository enabled. Now refreshing mirrors and installing any updates available..."
	sudo pacman -Syyuv --noconfirm
	echo "Done.\n"
	sleep 2s
}

groupinstall() {
	read -p "Continue adding required groups (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
		echo -e "Installing base groups..."
		sudo pacman -Syuv ${groups[@]}
		echo "Done.\n"
		sleep 2s
	else
		echo "Skipped..."
	fi
}

metapackage() {
	read -p "Continue building metapackage (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
		echo -e "Building and installing metapackage..."
		makepkg -C -c -d -f -i
		echo "Done.\n"
		sleep 2s
	else
		echo "Skipped..."
	fi
}

finish() {
	echo -e "All done.\n"
}

userrepository
refresh
groupinstall
metapackage
finish
