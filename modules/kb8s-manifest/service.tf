resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-example"
  }
  spec {
    selector = {
      App = "${kubernetes_pod.echo.metadata.0.labels.App}"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  } 

}

output "lb_ip" {
  value = "${kubernetes_service.echo.load_balancer_ingress.0.hostname}"
}