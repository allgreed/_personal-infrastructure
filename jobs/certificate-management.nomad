job "certificate-mangement" {
  datacenters = ["dc1"]

  type = "batch"

  periodic {
    cron             = "@daily"
    prohibit_overlap = true
  }

  group "certbot" {
    count = 1

    task "certbot" {
      driver = "docker"

      config {
        image = "certbot/certbot:v0.33.1"
        args = [
            "renew",
            "--webroot",
            "--noninteractive",
            "--webroot-path", "/srv",
        ]

        volumes = [
            "/etc/letsencrypt/:/etc/letsencrypt/",
            "/srv:/srv",
        ]
      }

      resources {
        cpu    = 200
        memory = 50
      }
    }
  }
}

