#
# Cookbook Name:: capistrano-rails
# Resource:: secrets
#
# Copyright 2015, Joe Yates

actions :create
default_action :create

attribute :directory, kind_of: String, name_attribute: true, required: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :mode, kind_of: Integer, default: 0600
attribute :environment, kind_of: String, default: "production"
attribute :secret_key_base, kind_of: String, required: true
attribute :other_secrets, kind_of: Hash, default: {}
