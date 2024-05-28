#
# ~/.bash_profile
#

[[ -f ~/.profile ]] && . ~/.profile

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Load profiles from ~/.profile.d
if test -d ~/.profile.d/; then
	for profile in ~/.profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi
