{
  "chef-server": {
    "accept_license": "true",
    "addons": ${jsonencode(addons)},
    "topology": "standalone",
    "version": "${version}"
  }
}
