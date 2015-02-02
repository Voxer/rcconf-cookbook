#
# Cookbook Name: rcconf
# Resource: default
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com>
#

actions :create, :create_if_missing, :remove
default_action :create

attribute :name, :name_attribute => true

attribute :path, :kind_of => String, :default => '/etc/rc.conf'
attribute :key,  :kind_of => String
attribute :value
