locals {
  hosts = [
    { name    = "aws-au",
      bastion = data.tfe_outputs.aws-au-shared.values.bastion-ssh,
      host    = data.tfe_outputs.aws-au.values.debug-ssh,
      ip      = data.tfe_outputs.aws-au.values.debug-ip,
    },
    { name    = "aws-us",
      bastion = data.tfe_outputs.aws-us-shared.values.bastion-ssh,
      host    = data.tfe_outputs.aws-us.values.debug-ssh,
      ip      = data.tfe_outputs.aws-us.values.debug-ip,
    },
    {
      name    = "gcp-au",
      bastion = null,
      host    = data.tfe_outputs.gcp-au.values.debug-ssh,
      ip      = data.tfe_outputs.gcp-au.values.debug-ip,
    },
    {
      name    = "gcp-us",
      bastion = null,
      host    = data.tfe_outputs.gcp-us.values.debug-ssh,
      ip      = data.tfe_outputs.gcp-us.values.debug-ip,
    },
  ]
}

output "exec" {
  value = nonsensitive(<<EOF
%{for source in local.hosts~}
%{for dest in local.hosts~}
%{if source.name != dest.name~}
%{if source.bastion != null~}
endlessRemote "$(check ${source.name} ${dest.name} ${dest.ip})" ${source.bastion} ${source.host} &
%{else~}
endlessRemote "$(check ${source.name} ${dest.name} ${dest.ip})" ${source.host} &
%{endif~}
%{endif~}
%{endfor~}
%{endfor~}
wait
EOF
  )
}
