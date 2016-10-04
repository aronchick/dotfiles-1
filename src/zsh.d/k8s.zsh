if command -v kubectl >/dev/null 2>&1; then
  . <(kubectl completion zsh)

  kc() {
    if [ ! -z ${KUBE_NAMESPACE+x} ]; then
      kubectl --namespace $KUBE_NAMESPACE "$@"
    else
      kubectl "$@"
    fi
  }
  
  alias kc='kubectl'
  # get autocompletions from kubectl command
  compdef kc=kubectl
fi
