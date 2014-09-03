#
# Cookbook Name: rcconf
# Library: provider_default
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com
#

require 'chef/resource'

class Chef
  class Resource
    class Rcconf < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :rcconf
        @provider = Chef::Provider::Rcconf
        @action = :create
        @allowed_actions = [:create, :create_if_missing, :remove]

        @path = '/etc/rc.conf'
        @key = name
      end

      def path(arg=nil)
        set_or_return(:path, arg, :kind_of => String)
      end

      def key(arg=nil)
        set_or_return(:key, arg, :kind_of => String)
      end

      def value(arg=nil)
        set_or_return(:value, arg, {})
      end
    end
  end
end
