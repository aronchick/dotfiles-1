if [ -d "${HOME}"/.dotfiles ]; then
    for DOT_FILE in $( ls -A "${HOME}"/.dotfiles/ln/ )
    do
            ln -s "${HOME}"/"${DOT_FILE}" "${HOME}"/.dotfiles/ln/"${DOT_FILE}"
    done
fi

