#
# Cookbook Name: rcconf
# Library: provider_default
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com>
#

use_inline_resources

action :create do
  doit :create, new_resource
end

action :remove do
  doit :remove, new_resource
end

action :create_if_missing do
  doit :create_if_missing, new_resource
end

def doit(action, new_resource)
  path = new_resource.path
  key = new_resource.key || new_resource.name
  value = new_resource.value.to_s.inspect

  Chef::Log.debug "#{action} #{key}=#{value} in #{path}"

  file "#{action} #{key} in #{path}" do
    path path
    content lazy {
      # delete all instances of the key and append it to the end if apporpriate
      lines = get_lines path
      lines.delete_if { |l| key_matches?(l, key) }
      lines << "#{key}=#{value}" unless action == :remove
      lines.join("\n") + "\n"
    }
    not_if {
      # don't do anything if we are removing a variable and it is not found
      remove = false
      if action == :remove then
        remove = true
        found = key_found?(get_lines(path), key)
        Chef::Log.debug "rcconf :remove - key '#{key}' found in config? - #{found}"
      end
      remove and not found
    }
    not_if {
      # don't do anything if we are create_if_missing a variable and it is found
      create = false
      if action == :create_if_missing then
        create = true
        found = key_found?(get_lines(path), key)
        Chef::Log.debug "rcconf :create_if_missing - key '#{key}' found in config? - #{found}"
      end
      create and found
    }
    not_if {
      # don't do anything if the value is alread set correctly
      create = false
      if action == :create then
        create = true
        lines = find_keys(get_lines(path), key)
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
  ::IO.read(path).split("\n")
end

# why-run supported
def whyrun_supported?
  true
end
