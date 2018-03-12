if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)

  if [ $commands[fzf] ]; then
    # helper for setting a namespace
    # List namespaces, preview the pods within, and save as variable
    function kcns() {
        namespaces=$(kubectl get ns -o=custom-columns=:.metadata.name)
        export KUBE_NAMESPACE=$(echo $namespaces | fzf --select-1 --preview "kubectl --namespace {} get pods")
        echo "Set namespace to $KUBE_NAMESPACE"
    }
  fi

  alias kc='kubectl --namespace ${KUBE_NAMESPACE:-default} '

  kcsh() { kubectl exec -i -t "$@" /bin/bash }
fi
