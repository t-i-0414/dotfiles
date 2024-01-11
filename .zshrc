# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

setopt incappendhistory

# ===========================
# environment variables
# ===========================

# terminal
export LANG="ja_JP.UTF-8"
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export DIRSTACKSIZE=100

# PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# flutter
export PATH="$PATH":"$HOME/.pub-cache/bin"

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"

# rust
export RUST_WITHOUT="rust-docs"

# asdf direnv
export ASDF_DIRENV_IGNORE_MISSING_PLUGINS=1

# rdbg
export RUBY_DEBUG_DAP_SHOW_PROTOCOL=1

# mysql
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"

# ===========================
# on startup
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

# ===========================
# asdf
# ===========================
# . /opt/homebrew/opt/asdf/libexec/asdf.sh
. /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh

# ===========================
# starship
# ===========================
eval "$(starship init zsh)"

# ===========================
# zsh-autosuggestions
# ===========================
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ===========================
# zsh-syntax-highlighting
# ===========================
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

# ===========================
# alias
# ===========================

# git
alias g='git'
alias ga='git add'
alias gcm='git commit -m'
alias gc='git commit'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gs='git switch'
alias gsb='git switch -c'
alias gp='git push'
alias gpl='git pull'
alias gst='git stash'
alias gsl='git stash list'
alias gsu='git stash -u'
alias gsa='git stash apply'
alias gsx='git stash drop'

# docker
alias d='docker'
alias di='docker images'
alias db='docker build'
alias dbx='docker buildx build --platform linux/amd64'
alias dr='docker rm'
alias dri='docker rmi'
alias dl='docker ps'
alias dla='docker ps -a'

# terraform
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'

# grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# ls
alias l.='ls -d .* --color=auto'
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'

# lsof
alias lfi='lsof -i:'
alias pshttpd='ps aux | grep httpd'

# saml2aws
alias samlsetup="bash -c 'read -sp \"ClientID: \" client_id && echo && read -sp \"ClientSecret: \" client_secret && echo && saml2aws configure --client-id=\$client_id --client-secret=\$client_secret'"
alias awslogin='saml2aws login --skip-prompt --force'
alias awsprofile='aws --profile saml sts get-caller-identity'

# sed
alias sed='gsed'

# takudev
alias postgreslogin='PGPASSWORD=Password psql --host=strapi-database.cdmqrmfenrch.ap-northeast-1.rds.amazonaws.com --port=5432 --username=postgres --password'
alias startpm2='pm2 start ~/ecosystem.config.js'
alias stoppm2='pm2 stop ~/ecosystem.config.js'

# ===========================
# functions
# ===========================
function checkout_origin_pr {
  git fetch origin pull/$argv/head:$argv && git checkout $argv
}

function checkout_upstream_pr {
  git fetch upstream pull/$argv/head:$argv && git checkout $argv
}

function start_takudev_cms_server {
  instanceId=`aws ec2 describe-instances \
    --filters 'Name=tag:Name,Values=strapi-web-server' \
    --query 'Reservations[*].Instances[].InstanceId' \
    --output text`

  aws ec2 start-instances \
    --instance-id $instanceId \
    --output text \
    --color on
}

function stop_takudev_cms_server {
  instanceId=`aws ec2 describe-instances \
    --filters 'Name=tag:Name,Values=strapi-web-server' \
    --query 'Reservations[*].Instances[].InstanceId' \
    --output text`

  aws ec2 stop-instances \
    --instance-id $instanceId \
    --output text \
    --color on
}

function get_takudev_cms_server_status {
  aws ec2 describe-instances \
    --filters 'Name=tag:Name,Values=strapi-web-server' \
    --query 'Reservations[*].Instances[].State' \
    --output text
}


# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
