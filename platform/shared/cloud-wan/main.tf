resource "awscc_networkmanager_global_network" "main" {

}

resource "awscc_networkmanager_core_network" "main" {
  global_network_id = awscc_networkmanager_global_network.example.id
  description       = "example"
}


resource "aws_networkmanager_global_network" "scaleout" {
  description = "scaleout"
}
//
//resource "aws_networkmanager_transit_gateway_peering" "example" {
//  core_network_id     = awscc_networkmanager_core_network.example.id
//  transit_gateway_arn = aws_ec2_transit_gateway.example.arn
//}
