maintainer       "James Hu"
maintainer_email "axsuul@gmail.com"
license          "All rights reserved"
description      "Cookbook for installing piwik"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe           "default", "Installs piwik"
recipe           "rails", "Ruby on Rails"

depends          "database"
depends          "mysql"
depends          "nginx"