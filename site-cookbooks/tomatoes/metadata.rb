name              "tomatoes"
maintainer        "Someone"
maintainer_email  "your_email@example.com"
license           "MIT"
description       "Installs and configures nginx, git and node.js"
version           "0.0.1"

recipe "tomatoes", "Installs nginx configuration, git and node.js"
recipe "tomatoes::node_js", "Installs only node.js"

depends "build-essential"