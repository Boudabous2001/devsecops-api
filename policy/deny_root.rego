# policy/deny_root.rego
# Règle Conftest : refuser tout pod Kubernetes qui tourne en root

package main

# Refuser si runAsNonRoot est absent ou false
deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext.runAsNonRoot == true
  msg := sprintf("ERREUR : le conteneur '%v' doit avoir runAsNonRoot: true", [container.name])
}

# Refuser si allowPrivilegeEscalation n'est pas explicitement false
deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext.allowPrivilegeEscalation == false
  msg := sprintf("ERREUR : le conteneur '%v' doit avoir allowPrivilegeEscalation: false", [container.name])
}

# Refuser si runAsUser est 0 (root)
deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.runAsUser == 0
  msg := sprintf("ERREUR : le conteneur '%v' ne peut pas tourner en tant que root (runAsUser: 0)", [container.name])
}
