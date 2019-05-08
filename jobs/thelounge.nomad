job "the_longue" {
  datacenters = ["dc1"]

  group "the_lounge" {
    count = 1

    task "main" {
      driver = "docker"

      config {
        # TODO: How to manage versions - can I get this from consul maybe and rerun the job on changes :D ???
        image = "thelounge/thelounge:3.0.1"
        port_map = {
            http = 9000
        }
        volumes = [
            "/var/eph/thelounge:/var/opt/thelounge",
        ]
      }

      resources {
        cpu    = 500
        memory = 100

        network {
            port "http" {
                static = "9000"
            }
        }
      }
    }
  }
}
