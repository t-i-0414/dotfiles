# Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
setopt incappendhistory

# ===========================
# environment variables
# ===========================

# Load environment variables
[[ -f ~/.zsh_envvars ]] && source ~/.zsh_envvars

# Basic environment settings
export LANG="ja_JP.UTF-8"
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export DIRSTACKSIZE=100

# PATH settings
typeset -U path PATH

# Setup Homebrew paths based on OS and architecture
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon Mac
    path=(
      /opt/homebrew/bin
      /opt/homebrew/sbin
      /usr/local/bin
      $path
    )
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    # Intel Mac
    path=(
      /usr/local/bin
      /usr/local/sbin
      $path
    )
    export HOMEBREW_PREFIX="/usr/local"
  fi
else
  # Linux
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi
fi

# Development environments
export ANDROID_HOME=$HOME/Library/Android/sdk
path=(
  $ANDROID_HOME/emulator
  $ANDROID_HOME/platform-tools
  $path
)

# Tool configurations
export RUST_WITHOUT="rust-docs"
export ASDF_DIRENV_IGNORE_MISSING_PLUGINS=1
export ASDF_DATA_DIR="$HOME/.asdf"
path=("$ASDF_DATA_DIR/shims" $path)
export PATH

# Development settings
export RUBY_DEBUG_DAP_SHOW_PROTOCOL=1
export AWS_PROFILE="default"

# ===========================
# zsh options
# ===========================

setopt hist_ignore_dups     # 直前のコマンドの重複を削除
setopt hist_ignore_all_dups # 同じコマンドをヒストリに残さない
setopt share_history        # 同時に起動したzshの間でヒストリを共有
setopt correct              # コマンドのスペルを訂正
setopt no_beep              # ビープ音を鳴らさない
setopt AUTO_PUSHD           # ディレクトリを移動したら自動的にpushd

# ===========================
# platform specific settings
# ===========================

# Platform specific settings
if [[ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
fi

# ===========================
# plugins & tools
# ===========================

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# zsh plugins
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
  if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
  fi
fi

# ===========================
# aliases & functions
# ===========================

# Load custom aliases if exists
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Base aliases
alias g='git'
alias d='docker'
alias tf='terraform'

# Docker aliases
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

# Terraform aliases
alias tfp='terraform plan'
alias tfa='terraform apply'

# System aliases
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias l.='ls -d .* --color=auto'
alias sed='gsed'

# Development workflow aliases
alias gm='brew update && brew upgrade && brew cleanup && brew autoremove && brew doctor'
alias cdr='cd $(git rev-parse --show-toplevel)'
alias saml2awssetup="bash -c 'read -sp \"ClientID: \" client_id && echo && read -sp \"ClientSecret: \" client_secret && echo && saml2aws configure --client-id=\$client_id --client-secret=\$client_secret'"
alias saml2awslogin='saml2aws login --session-duration 14400 --force --skip-prompt --browser-type=chrome'
alias awsprofile='aws --profile default sts get-caller-identity'

# Load custom functions if exists
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Git workflow functions
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
