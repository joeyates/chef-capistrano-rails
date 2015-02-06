#
# Cookbook Name:: capistrano-rails
# Resource:: secrets
#
# Copyright 2015, Joe Yates

ALL_ATTRIBUTES = %i(
  base_path user group file_mode environment secret_key_base other_secrets
)

actions :create
default_action :create

attribute :base_path, kind_of: String, name_attribute: true, required: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :file_mode, kind_of: Integer, default: 0600
attribute :environment, kind_of: String, default: "production"
attribute :secret_key_base, kind_of: String, required: true
attribute :other_secrets, kind_of: Hash, default: {}
