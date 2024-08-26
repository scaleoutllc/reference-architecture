data "external" "host" {
  program = ["bash", "-c", <<EOT
    if [ "$(uname)" = "Linux" ] || [ "$(uname)" = "Darwin" ]; then
      echo "{\"name\": \"$(whoami)\"}"
    elif [ "$(uname -o 2>/dev/null)" = "Msys" ] || [ -n "$COMSPEC" ]; then
      echo "{\"name\": \"$(echo %USERNAME%)\"}"
    else
      echo "{\"name\": \"Unsupported OS\"}"
    fi
  EOT
  ]
}

output "name" {
  value = data.external.host.result.name
}
