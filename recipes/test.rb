#
# Cookbook Name: rcconf
# Recipe: test
#
# Copyright:: Copyright (c) 2014, Voxer LLC
# License: MIT License
# Author: Dave Eddy <dave@daveeddy.com
#

rcconf 'some_key' do
  value 'some_value'
end

rcconf 'Explicit Example' do
  key 'explicit_key'
  value 42 # this will be .to_s.inspect'd
end

rcconf 'Create Foobar if_missing' do
  key 'foobar'
  value 'baz'
  action :create_if_missing
end

# should do nothing
rcconf 'Create Foobar if_missing (again)' do
  key 'foobar'
  value 'bat'
  action :create_if_missing
end

rcconf 'Remove Foobar' do
  key 'foobar'
  action :remove
end

rcconf 'explicit_key' do
  action :remove
end

rcconf 'Remove some_key' do
  key 'some_key'
  action :remove
end
