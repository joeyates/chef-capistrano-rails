#
# Cookbook Name:: capistrano-rails
# Resource:: directories
#
# Copyright 2015, Joe Yates

ALL_ATTRIBUTES = %i(base_path user group directory_mode extra_shared)

actions :create
default_action :create

attribute :base_path, kind_of: String, name_attribute: true, required: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :directory_mode, kind_of: Integer, default: 0755
attribute :extra_shared, kind_of: Array, default: []

attr_accessor :paths
