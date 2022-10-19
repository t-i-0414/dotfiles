# git
alias g='git'
alias ga='git add'
alias gcm='git commit -m'
alias gs='git switch'
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

# exa
if type "exa" > /dev/null 2>&1; then
  alias l='exa --icons --git'
  alias ls='l'
  alias la='exa -a --icons --git'
  alias ll='exa -aahl --icons --git'
  alias lt='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
fi

# bat
if type "bat" > /dev/null 2>&1; then
  alias cat='bat'
fi

# other
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias pshttpd='ps aux | grep httpd'
alias awslogin='saml2aws login --skip-prompt --force'
alias awsprofile='aws --profile saml sts get-caller-identity'
alias samlsetup="bash -c 'read -sp \"ClientID: \" client_id && echo && read -sp \"ClientSecret: \" client_secret && echo && saml2aws configure --client-id=\$client_id --client-secret=\$client_secret'"
