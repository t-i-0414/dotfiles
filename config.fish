starship init fish | source

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias lfi='lsof -i:'
alias pshttpd='ps aux | grep httpd'
alias awslogin='saml2aws login --skip-prompt --force'
alias awsprofile='aws --profile saml sts get-caller-identity'
alias samlsetup="bash -c 'read -sp \"ClientID: \" client_id && echo && read -sp \"ClientSecret: \" client_secret && echo && saml2aws configure --client-id=\$client_id --client-secret=\$client_secret'"

function checkoutpr
  git fetch upstream pull/$argv/head:$argv && git checkout $argv
end
