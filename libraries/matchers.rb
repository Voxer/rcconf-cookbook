#
# Cookbook Name: rcconf
# Library: matchers
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com
#

if defined?(ChefSpec)
  def create_rcconf(message)
    ChefSpec::Matchers::ResourceMatcher.new(:rcconf, :create, message)
  end


  def create_rcconf_if_missing(message)
    ChefSpec::Matchers::ResourceMatcher.new(:rcconf, :create_if_missing, message)
  end


  def remove_rcconf(message)
    ChefSpec::Matchers::ResourceMatcher.new(:rcconf, :remove, message)
  end
end
