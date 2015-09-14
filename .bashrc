# Go environment
export GOPATH="$HOME/Go/external:$HOME/Go/uchoa:$HOME/Go/vtex:$HOME/Go/fisioplex"
export GOROOT="/usr/local/go"
# BEGIN export PATH="$PATH:$GOPATH/bin"
gopatharr=$(echo $GOPATH | tr ":" "\n")
auxpath=$PATH
for segment in $gopatharr
do
	auxpath="$auxpath:$segment/bin"
done
export PATH=".:$auxpath"
# END export PATH="$PATH:$GOPATH/bin"
source dnvm.sh

code () {
	if [[ $# = 0 ]]
	then
		open -a "Visual Studio Code"
	else
		[[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
		open -a "Visual Studio Code" --args "$F"
	fi
}
