kc() {
  if [ ! -z ${KUBE_NAMESPACE+x} ]; then
    kubectl --namespace $KUBE_NAMESPACE "$@"
  else
    kubectl "$@"
  fi
}
