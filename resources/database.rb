#
# Cookbook Name:: capistrano-rails
# Resource:: database
#
# Copyright 2015, Joe Yates

ALL_ATTRIBUTES = %i(
  base_path user group file_mode environment
  adapter database username password connection_options
  other_databases
)

actions :create
default_action :create

attribute :base_path, kind_of: String, name_attribute: true, required: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :file_mode, kind_of: Integer, default: 0600
attribute :environment, kind_of: String, default: "production"
attribute :adapter, kind_of: String, required: true
attribute :database, kind_of: String, required: true
attribute :username, kind_of: String, required: true
attribute :password, kind_of: String, required: true
attribute :connection_options, kind_of: Hash, default: {}
attribute :other_databases, kind_of: Hash, default: {}
