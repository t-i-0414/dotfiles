starship init fish | source

# git
alias g='git'
alias ga='git add'
alias gcm='git commit -m'
alias gc='git commit'
alias gco='git checkout'
alias gcob='git checkout -b'
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

# other
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

function startstrapiwebserver
  for i in (
    aws ec2 describe-instances \
        --filters 'Name=tag:Name,Values=strapi-web-server' \
        --query 'Reservations[*].Instances[].InstanceId' \
        --output text
  )
    aws ec2 start-instances \
    --instance-ids {$i} \
    --output text \
    --color on
  end
end

function stopstrapiwebserver
  for i in (
    aws ec2 describe-instances \
        --filters 'Name=tag:Name,Values=strapi-web-server' \
        --query 'Reservations[*].Instances[].InstanceId' \
        --output text
  )
    aws ec2 stop-instances \
    --instance-ids {$i} \
    --output text \
    --color on
  end
end
