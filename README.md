# chef-capistrano-rails

A chef recipe to set up directories and configuration files for a
Rails deployment 

# Chef and Capistrano

These resources prepare the directories and minimal configuration files
to prepare for Capistrano deployment.

# Directives

* `capistrano_rails_directories` - maintains the minimal set of directories
  to permit deployment,
* `capistrano_rails_database` - creates `shared/config/database.yml`,
* `capistrano_rails_secrets` - creates `shared/config/secrets.yml`.

## `capistrano_rails_directories`

Sets up the base directory, `shared` and its subdirectories.

Attributes:

* `path` - the deployment's base directory (defaults to the name of
  the directive)
* `user` - (required) the owner of the directory tree
* `group` - (required) the group owner of the directory tree
* `mode` - the permissions to set on directories. Default: 0755.
* `shared` - an Array of directories (along with `config`) to create
  under `shared`. Default: `[]`

Note: `shared/config` will get created even if it is not in the
  `shared` Array.

Example:

```ruby
capistrano_rails_directories "/var/www/my_app" do
  user "deploy"
  group "deploy"
  shared ["tmp/pids"]
end
```

## `capistrano_rails_database`

Creates or updates `shared/config/database.yml`.
You must have created `shared/config` beforehand.

Attributes:

* `path` - the deployment's directory (defaults to the name of the directive)
* `user` - (required) the owner of the file
* `group` - (required) the group owner of the file
* `mode` - the permissions to set on the file. Default: 0600.
* `database` - (required) the name of the database
* `username` - (required) the database user name
* `password` - (required) the database password
* `environment` - the Rails environment. Default: `production`
* `options` - a Hash of other options (e.g. `pool`, `encoding`, etc). Default: `{}`

The supplied configuration is merged into any existing file. So, multiple
`capistrano_rails_database` directives can be used for a single
deployment, as long as they are for different Rails environments.

Note: the directive does **not** manage the database itself.

## `capistrano_rails_secrets`

Creates `shared/config/secrets.yml`.

Attributes:

* `path` - the deployment's directory (defaults to the name of the directive),
* `secret_key_base` - (required) the application's `secret_key_base`,
* `secret_token` - (required) the application's `secret_token`,
* `other_secrets` - a Hash of other values to include in the file.

The supplied data is used to overwrite the content of any existing file.
