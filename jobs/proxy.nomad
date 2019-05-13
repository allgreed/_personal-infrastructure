job "proxy" {
  datacenters = ["dc1"]

  type = "system"

  update {
    auto_revert = true
  }

  group "nginx" {
    count = 1

    task "nginx" {
      driver = "docker"

      config {
        # TODO: How to manage versions - can I get this from consul maybe and rerun the job on changes :D ???
        image = "nginx:1.16-alpine"
        network_mode = "host"
        volumes = [
            "/srv:/usr/share/nginx/html/",
            "/etc/svc/nginx:/etc/nginx/conf.d/",
            "/etc/letsencrypt:/etc/letsencrypt",
        ]
      }

      resources {
        cpu    = 500
        memory = 100
      }
    }

  }
}

