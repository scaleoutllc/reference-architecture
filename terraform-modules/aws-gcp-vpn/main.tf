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

resource "random_password" "shared_secret" {
  length  = 16
  special = false
}
