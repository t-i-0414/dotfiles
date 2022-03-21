[ `uname -m` = 'x86_64' ] && echo "😀 Be careful, this is x86_64 Shell 😀"
[ `uname -m` = 'arm64' ] && echo "💪 You are on arm64 Shell 💪"

eval "$(/opt/homebrew/bin/brew shellenv)"
