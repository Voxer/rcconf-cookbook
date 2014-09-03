#
# Cookbook Name: rcconf
# Library: matchers
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com
#

if defined?(ChefSpec) then
  def rcconf_create(message)
    ChefSpec::Matchers::ResourceMatcher.new(:rcconf, :create, message)
  end
  def rcconf_create_if_missing(message)
    ChefSpec::Matchers::ResourceMatcher.new(:rcconf, :create_if_missing, message)
  end
  def rcconf_remove(message)
    ChefSpec::Matchers::ResourceMatcher.new(:rcconf, :remove, message)
  end
end
