#
# Cookbook Name:: capistrano-rails
# Resource:: application
#
# Copyright 2015, Joe Yates

actions :create
default_action :create

# shared
attribute :base_path, kind_of: String, name_attribute: true, required: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :environment, kind_of: String, default: "production"

attribute :directory_mode, kind_of: Integer, default: 0755
attribute :file_mode, kind_of: Integer, default: 0600

# directories
attribute :extra_shared, kind_of: Array, default: []

# database
attribute :adapter, kind_of: String, required: true
attribute :database, kind_of: String, required: true
attribute :username, kind_of: String, required: true
attribute :password, kind_of: String, required: true
attribute :connection_options, kind_of: Hash, default: {}
attribute :other_databases, kind_of: Hash, default: {}

# secrets
attribute :secret_key_base, kind_of: String, required: true
attribute :other_secrets, kind_of: Hash, default: {}
