# support bash autocompletion
# https://stackoverflow.com/questions/3249432/i-have-a-bash-tab-completion-script-is-t
autoload bashcompinit
bashcompinit

if [[ -f /usr/share/bash-completion/completions/lpass ]]; then
        source /usr/share/bash-completion/completions/lpass
fi
