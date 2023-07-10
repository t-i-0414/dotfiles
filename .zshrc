# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# ===========================
# 環境変数
# ===========================

# ターミナルの設定
export LANG="ja_JP.UTF-8"
export HISTFILE="~/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
export DIRSTACKSIZE=100

# rust
export RUST_WITHOUT="rust-docs"

# PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"
export CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)"

# ===========================
# 起動時コマンド
# ===========================

# 直前のコマンドの重複を削除
setopt hist_ignore_dups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# 同時に起動したzshの間でヒストリを共有
setopt share_history

# コマンドのスペルを訂正
setopt correct

# ビープ音を鳴らさない
setopt no_beep

# ディレクトリを移動したら自動的にpushd
setopt AUTO_PUSHD

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

# starship
eval "$(starship init zsh)"

if [[ -o interactive ]]; then
    exec fish
fi

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
