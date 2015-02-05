#
# Cookbook Name:: capistrano-rails
# Resource:: directories
#
# Copyright 2015, Joe Yates

actions :create
default_action :create

attribute :path, kind_of: String, name_attribute: true, required: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :mode, kind_of: Integer, default: 0755
attribute :extra_shared, kind_of: Array, default: []

attr_accessor :paths
