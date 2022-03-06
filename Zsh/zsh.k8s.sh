debug LOADING zsh.k8s.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_zshK8s ] && debug exiting zsh.k8s.sh && return 

# ---- k8s -----------------------------------------------------------------------

# Kubernetes-specific aliases and functions
function setupK8s() {
   alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm chenzj/dfimage" # find base image for a container OR docker image history
   alias dih='docker image history'
   alias k=kubectl
   alias k8=kubectl
   alias k8c='kubectl config '
   alias k8cg='kubectl config get-contexts'
   alias k8cs='kubectl config set-context'
   alias k8cu='kubectl config use-context'
   alias k8cv='kubectl config view'
   alias k8gn='kubectl get nodes -o wide'
   alias k8gp='kubectl get pods -o wide'
   alias k8gs='kubectl get services -o wide'
   alias k8ns='kubectl get ns'
   alias k8ga='kubectl get all -A -o wide'
   function k8describe() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift
      kubectl describe $_pod $*
   }
   function k8exec() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift
      kubectl exec -it $_pod -- ${k8execCmd:-bash} $*
   }
   function k8logs() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      kubectl logs "$2" $_pod # $2 for -f
   }
}

# help file to show all k8s commands
function k8help() {
   echo  dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm chenzj/dfimage" # find base image for a container OR docker image history
   echo  dih='docker image history'
   echo  k=kubectl
   echo  k8=kubectl
   echo  k8c='kubectl config '
   echo  k8cg='kubectl config get-contexts'
   echo  k8cs='kubectl config set-context'
   echo  k8cu='kubectl config use-context'
   echo  k8cv='kubectl config view'
   echo  k8gn='kubectl get nodes -o wide'
   echo  k8gp='kubectl get pods -o wide'
   echo  k8gs='kubectl get services -o wide'
   echo  k8ns='kubectl get ns'
   echo  k8ga='kubectl get all -A -o wide'
   echo '   function k8describe() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift
      kubectl describe $_pod $*
   }
   function k8exec() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift
      kubectl exec -it $_pod -- ${k8execCmd:-bash} $*
   }
   function k8logs() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      kubectl logs "$2" $_pod # $2 for -f
   }'
}

# EOF
