# resource "aws_globalaccelerator_accelerator" "main" {
#   name    = local.name
#   enabled = true
# }

# resource "aws_globalaccelerator_listener" "main" {
#   accelerator_arn = aws_globalaccelerator_accelerator.main.id
#   client_affinity = "SOURCE_IP"
#   protocol        = "TCP"
#   port_range {
#     from_port = 443
#     to_port   = 443
#   }
# }

