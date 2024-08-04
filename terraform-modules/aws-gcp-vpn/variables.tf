#                          aws transit gateway route table
#                                      |
#                                      |
#                             aws transit gateway
#                              /               \ 
#                             /                 \
#                            /                   \
#                         -------    2     2    -------
#                         | aws |----|     |----| aws |
#                         | vpn |  1 |     | 1  | vpn |
#                         | con |--| |     | |--| con |
#                         -------  | |     | |  -------
#                            |     | |     | |     |
#                            |     | |     | |     |
#                            |     | |     | |     | 
# aws customer gateway primary     | |     | |     aws customer gateway secondary
#             (bgp) |              | |     | |               | (bgp)
#                   |        google external vpn gateway     |
#                   |              0 1     2 3               |
#                   |              | |     | |               |  
#                    \             | |     | |              /
#                     \            | |     | |             /
#                      \--------gcp vpn ha gateway--------/
#                                  0 0     1 1 
#                            (bgp) | |     | | (bgp)
#                                  | |     | |
#                              google cloud router
#                                       |
#                                       |
#                             google vpc route tables
#
#


variable "name" {
  type = string
}

variable "aws" {
  type = object({
    asn                            = string
    transit_gateway_id             = string
    transit_gateway_route_table_id = string
  })
}

variable "gcp" {
  type = object({
    asn               = string
    region            = string
    additional_ranges = list(string)
    network_name      = string
    cloud_router_name = string
  })
}

