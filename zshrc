# adds the current branch name in green


if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $ref ]]; then
      echo "[%{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}]"
    fi
  }
fi

# makes color constants available
autoload -U colors
colors

# completion!
autoload -U compinit
compinit

# enable colored output from ls, etc
export CLICOLOR=1

# automatically enter directories without cd
setopt auto_cd

# expand functions in the prompt
setopt prompt_subst

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# keep TONS of history
export HISTSIZE=4096

# prompt
export PS1='$(git_prompt_info)[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}] '

# path
export GOPATH="$HOME/projects/go"
export GOBIN="$GOPATH/bin"


echo gothere
# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
export PGDATA=/usr/local/var/postgres
export PGHOST=/tmp

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

setopt AUTO_CD
setopt SHARE_HISTORY
