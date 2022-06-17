# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zprofile.pre.zsh"
[ `uname -m` = 'x86_64' ] && echo "😀 Be careful, this is x86_64 Shell 😀"
[ `uname -m` = 'arm64' ] && echo "💪 You are on arm64 Shell 💪"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zprofile.post.zsh"
