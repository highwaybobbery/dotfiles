# adds the current branch name in green
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo "[%{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}]"
  fi
}

# makes color constants available
autoload -U colors
colors

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
export PATH="$HOME/.rbenv/bin:$PATH"

# initialize rbenv
eval "$(rbenv init - zsh)"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
