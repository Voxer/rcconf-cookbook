#
# Cookbook Name: rcconf
# Library: provider_default
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com
#

class Chef
  class Provider
    class Rcconf < Chef::Provider
      def load_current_resource
        @current_resource ||= Chef::Resource::Rcconf.new(new_resource.name)

        @current_resource.path(new_resource.path)
        @current_resource.key(new_resource.key)
        @current_resource.value(new_resource.value)

        @current_resource
      end

      def action_create
        doit(:create)
      end

      def action_remove
        doit(:remove)
      end

      def action_create_if_missing
        doit(:create_if_missing)
      end

      def doit(action)
        path = @current_resource.path
        key = @current_resource.key || @current_resource.name
        value = @current_resource.value.to_s.inspect

        Chef::Log.debug "#{action} #{key}=#{value} in #{path}"

        t = file "#{action} #{key}=#{value} in #{path}" do
          path path
          content lazy {
            # delete all instances of the key and append it to the end if apporpriate
            lines = get_lines
            lines.delete_if { |l| key_matches?(l, key) }
            lines << "#{key}=#{value}" unless action == :remove
            lines.join("\n") + "\n"
          }
          not_if {
            # don't do anything if we are removing a variable and it is not found
            remove = false
            if action == :remove then
              remove = true
              found = key_found?(get_lines, key)
              Chef::Log.debug "rcconf :remove - key '#{key}' found in config? - #{found}"
            end
            remove and not found
          }
          not_if {
            # don't do anything if we are create_if_missing a variable and it is found
            create = false
            if action == :create_if_missing then
              create = true
              found = key_found?(get_lines, key)
              Chef::Log.debug "rcconf :create_if_missing - key '#{key}' found in config? - #{found}"
            end
            create and found
          }
          not_if {
            # don't do anything if the value is alread set correctly
            create = false
            if action == :create then
              create = true
              lines = find_keys(get_lines, key)
              num = lines.length
              Chef::Log.debug "rcconf :create - key '#{key}' found in config #{num} times"
              if num == 1 then
                iscorrect = "#{key}=#{value}" == lines.first
                Chef::Log.debug "rcconf :create - key '#{key}' correct in config? #{iscorrect}"
              end
            end
            create and num == 1 and iscorrect
          }
        end
        @current_resource.updated_by_last_action(t.updated_by_last_action?)
        t
      end

      # returns the number of times a key is found
      def find_keys(lines, key)
        lines.select { |l| key_matches?(l, key) }
      end

      # given an array of lines and a key name, this returns true if the key is found
      # at least once in the array
      def key_found?(lines, key)
        not lines.detect { |l| key_matches?(l, key) }.nil?
      end

      # given a line (String) and a keyname, this returns true if the line matches
      # the key in rc.conf format
      def key_matches?(line, key)
        line.start_with? "#{key}="
      end

      # return the current rc.conf file as an array of lines as Strings without
      # trailing newline characters
      def get_lines
        ::IO.read(@current_resource.path).split("\n")
      end

      # why-run supported
      def whyrun_supported?
        true
      end
    end
  end
end
