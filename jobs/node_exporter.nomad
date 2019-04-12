job "metrics" {
  datacenters = ["dc1"]

  type = "system"

  update {
    auto_revert = true
  }

  group "node_metrics" {
    count = 1

    task "node_exporter" {
      driver = "docker"

      config {
        # TODO: How to manage versions - can I get this from consul maybe and rerun the job on changes :D ???
        image = "quay.io/prometheus/node-exporter:v0.17.0"
        args = ["--path.rootfs", "/host"]
        network_mode = "host"
        pid_mode = "host"
        volumes = [
            "/:/host:ro,rslave",
        ]
      }

      resources {
        cpu    = 100
        memory = 50
      }
    }
  }
}
