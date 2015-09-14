# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

test -f ~/.git-completion.bash && . $_

export PS1="\u@\h: \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

alias sudomacs="sudo -b /Applications/Emacs.app/Contents/MacOS/Emacs"
alias emacs="open -a /Applications/Emacs.app/Contents/MacOS/Emacs"
alias sublime="open -a /Applications/Sublime\ Text\ 2.app/Contents/MacOS/Sublime\ Text\ 2"

alias fixow='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user;killall Finder;echo "Open With has been rebuilt; Finder will relaunch."'

mitm() {
	local ntwsvc=$1;
	if [ -z $ntwsvc]; then
		ntwsvc="Wi-Fi";
	fi
	echo "Binding mitmproxy to '$ntwsvc' ...";
	sudo networksetup -setwebproxy "$ntwsvc" 127.0.0.1 8080;
	sudo networksetup -setsecurewebproxy "$ntwsvc" 127.0.0.1 8080;
	mitmproxy;
	sudo networksetup -setwebproxystate "$ntwsvc" off;
	sudo networksetup -setsecurewebproxystate "$ntwsvc" off;
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[ -s "/Users/uchoa/.kre/kvm/kvm.sh" ] && . "/Users/uchoa/.kre/kvm/kvm.sh" # Load kvm
