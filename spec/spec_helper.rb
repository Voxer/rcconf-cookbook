#
# Cookbook Name: rcconf
# Library: matchers
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com
#

require 'chefspec'
require_relative 'chefspec_patch'
at_exit { ChefSpec::Coverage.report! }
