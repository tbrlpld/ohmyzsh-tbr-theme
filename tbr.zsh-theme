function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo "$"; fi
}


# Full path unless in git repo. Then only path from repo root.
# Shamelessly copied from: https://github.com/shashankmehta/dotfiles/blob/master/thesetup/zsh/.oh-my-zsh/custom/themes/gitster.zsh-theme
function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

# git status variables
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[cyan]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}—%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[green]%}»%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[white]%}#%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[blue]%}?%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[yellow]%}$%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[blue]%} •|%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[blue]%} |•%{$reset_color%}"


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Checks if working tree is dirty. 
# This is copied from the original implementation
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    case "$GIT_STATUS_IGNORE_SUBMODULES" in
      git)
        # let git decide (this respects per-repo config in .gitmodules)
        ;;
      *)
        # if unset: ignore dirty submodules
        # other values are passed to --ignore-submodules
        FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
        ;;
    esac
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    # This line is changed to show the prompt status inside the git_prompt_info
    current_status=$(git_prompt_status)
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY$current_status"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# EXAMPLE
# PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
#
# GENTOO
# PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)$(prompt_char)%{$reset_color%} '
#
# Mine
# PROMPT='%(!.%{$fg[red]%}.%{$fg[magenta]%}%n@)%m %{$fg[blue]%}%(!.%1~.%~) $(git_prompt_info)%{$fg_bold[blue]%}$(prompt_char)%{$reset_color%} '
# PROMPT='%(!.%{$fg[red]%}.%{$fg[magenta]%}%n@)%m %{$fg[blue]%}$(get_pwd) $(git_prompt_info)%{$fg_bold[blue]%}$(prompt_char)%{$reset_color%} '
PROMPT='%(!.%{$fg[red]%}.) %{$fg[blue]%}$(get_pwd) $(git_prompt_info)%{$fg_bold[blue]%}$(prompt_char)%{$reset_color%} '

