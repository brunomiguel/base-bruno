#! /bin/bash -e

groups=(
  "base-devel"
)

forceclose() {
	echo -e "\n\nForcing script termination..."
	sleep 0.5s
	echo -e "Terminated. Bye!"
}
trap forceclose EXIT

userrepository() {
	local cont
	read -p "Continue adding userrepository repo (Y/n)?" cont
	if [[ ${cont,,} =~ ^(yes|y| ) ]] || [[ -z ${cont,,} ]]; then
		echo -e "Adding userrepository to /etc/pacman.conf..."
		sudo tee -a /etc/pacman.conf <<EOD

[userrepository]
Server = https://userrepository.eu
SigLevel = Optional TrustAll
EOD
		echo -e "Done.\n"
		sleep 2s
	else
		echo -e "Skipped an essential step. Aborting..."
		exit 0
	fi
}

refresh() {
	echo -e "Userrepository enabled. Now refreshing mirrors and installing any updates available..."
	sudo pacman -Syyuv --noconfirm
	echo -e "Done.\n"
	sleep 2s
}

groupinstall() {
	local cont
	read -p "Continue adding required groups (Y/n)?" cont
	if [[ ${cont,,} =~ ^(yes|y| ) ]] || [[ -z ${cont,,} ]]; then
		echo -e "Installing base groups..."
		sudo pacman -Syuv "${groups[@]}"
		echo -e "Done.\n"
		sleep 2s
	else
		echo "Skipped..."
	fi
}

metapackage() {
	local cont
	read -p "Continue building metapackage (Y/n)?" cont
	if [[ ${cont,,} =~ ^(yes|y| ) ]] || [[ -z ${cont,,} ]]; then
		echo -e "Building and installing metapackage..."
		makepkg -C -c -d -f -i
		echo -e "Done.\n"
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
