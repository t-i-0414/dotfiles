# Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
setopt incappendhistory

# ===========================
# environment variables
# ===========================

if [ -f ~/.zsh_envvars ]; then
  source ~/.zsh_envvars
fi

# terminal
export LANG="ja_JP.UTF-8"
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export DIRSTACKSIZE=100

# PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# rust
export RUST_WITHOUT="rust-docs"

# asdf direnv
export ASDF_DIRENV_IGNORE_MISSING_PLUGINS=1
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# rdbg
export RUBY_DEBUG_DAP_SHOW_PROTOCOL=1

# aws
export AWS_PROFILE="default"

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
# homebrew(Linux)
# ===========================
if [[ "$(uname)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ===========================
# asdf
# ===========================
if [ "$(uname)" = 'Darwin' ]; then
  # . /opt/homebrew/opt/asdf/libexec/asdf.sh
else
  # . /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
fi

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

if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

# git
alias g='git'

# docker
alias d='docker'
alias di='docker images'
alias db='docker build'
alias dbx='docker buildx build --platform linux/amd64'
alias dr='docker rm'
alias dri='docker rmi'
alias dl='docker ps'
alias dla='docker ps -a'
alias dpa='docker system prune -a'
alias dpa24='docker system prune -a --filter "until=24h"'
alias dpv='docker volume prune'

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

# saml2aws
alias saml2awssetup="bash -c 'read -sp \"ClientID: \" client_id && echo && read -sp \"ClientSecret: \" client_secret && echo && saml2aws configure --client-id=\$client_id --client-secret=\$client_secret'"
alias saml2awslogin='saml2aws login --session-duration 14400 --force --skip-prompt --browser-type=chrome'

# aws
alias awsprofile='aws --profile default sts get-caller-identity'

# sed
alias sed='gsed'

# good morning
alias gm='brew update && brew upgrade && brew cleanup && brew autoremove && brew doctor'

# cd to the root of the git project
alias cdr='cd $(git rev-parse --show-toplevel)'

# ===========================
# functions
# ===========================

if [ -f ~/.zsh_functions ]; then
  source ~/.zsh_functions
fi

function checkout_origin_pr {
  if [[ $# -ne 1 ]]; then
    echo "Usage: checkout_origin_pr <PR_NUMBER>"
    return 1
  fi

  local pr_number=$1
  local pr_branch="pr-$pr_number"

  echo "Fetching PR #$pr_number from origin..."

  if ! git fetch origin "pull/$pr_number/head:$pr_branch"; then
    echo "Error: Failed to fetch PR #$pr_number"
    return 1
  fi

  echo "Checking out PR #$pr_number as $pr_branch"
  git checkout "$pr_branch"
}
alias gcpr='checkout_origin_pr'

function checkout_upstream_pr {
  if [[ $# -ne 1 ]]; then
    echo "Usage: checkout_upstream_pr <PR_NUMBER>"
    return 1
  fi

  local pr_number=$1
  local pr_branch="upstream-pr-$pr_number"

  echo "Fetching PR #$pr_number from upstream..."

  if ! git fetch upstream "pull/$pr_number/head:$pr_branch"; then
    echo "Error: Failed to fetch PR #$pr_number"
    return 1
  fi

  echo "Checking out PR #$pr_number as $pr_branch"
  git checkout "$pr_branch"
}
alias gcupr='checkout_upstream_pr'

function checkout_merge_base_commit {
  if [[ $# -ne 3 ]]; then
    echo "Usage: checkout_merge_base_commit <new-branch-name> <branch-A> <branch-B>"
    return 1
  fi

  local new_branch=$1
  local branch_a=$2
  local branch_b=$3

  local base_commit
  if ! base_commit=$(git merge-base "$branch_a" "$branch_b"); then
    echo "Error: Failed to find merge-base between $branch_a and $branch_b"
    return 1
  fi

  echo "Creating branch '$new_branch' at merge-base commit $base_commit..."
  if ! git branch "$new_branch" "$base_commit"; then
    echo "Error: Failed to create branch '$new_branch'"
    return 1
  fi

  echo "Switching to branch '$new_branch'"
  if ! git checkout "$new_branch"; then
    echo "Error: Failed to checkout branch '$new_branch'"
    return 1
  fi
}
alias gcmb='checkout_merge_base_commit'

function git_switch_branch_with_suffix() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: git_switch_branch_with_suffix <suffix>"
    return 1
  fi

  local suffix=$1

  local current_branch
  if ! current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
    echo "Error: Not a git repository or cannot determine the current branch."
    return 1
  fi

  local new_branch="${current_branch}-${suffix}"
  if git show-ref --verify --quiet "refs/heads/$new_branch"; then
    echo "Error: Branch '$new_branch' already exists."
    return 1
  fi

  echo "Creating and switching to branch: $new_branch"
  if ! git switch -c "$new_branch"; then
    echo "Error: Failed to create and switch to branch '$new_branch'."
    return 1
  fi
}
alias gscws='git_switch_branch_with_suffix'

function update_git_repos() {
  local BASE_DIR="$HOME/workspace"

  if [[ ! -d "$BASE_DIR" ]]; then
    echo "Error: BASE_DIR ($BASE_DIR) does not exist."
    return 1
  fi

  for dir in "$BASE_DIR"/*/; do
    if [[ -d "$dir" && -d "$dir/.git" ]]; then
      echo "Processing: $dir"
      cd "$dir" || continue

      local DEFAULT_BRANCH
      DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

      if [[ -n "$DEFAULT_BRANCH" ]]; then
        echo "Pulling latest changes from $DEFAULT_BRANCH..."
        git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"
      else
        echo "Warning: Could not determine default branch for $dir"
      fi

      cd "$BASE_DIR" || return 1
    else
      echo "Skipping (not a git repository): $dir"
    fi
  done

  echo "All repositories updated."
}
alias ugr='update_git_repos'

# Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
