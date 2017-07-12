# chef-capistrano-rails

`capistrano-rails` provides chef resources which handle directories and
configuration files for [Capistrano][capistrano] [Rails][rails] deployments.

[chef]: http://en.wikipedia.org/wiki/Chef_%28software%29
[capistrano]: http://capistranorb.com/
[rails]: http://rubyonrails.org/

# Resources

* directories - maintains the minimal set of directories to permit
  deployment
* database - maintains `database.yml`
* secrets - maintains `secrets.yml`
* application - the one-stop shop: directories, database and secrets in one
  resource.

These resources manage the directories and minimal configuration files
for Capistrano deployment of a Rails application.

# Configuration

For Rails 4 with Capistrano 3, use the following in your Rails project's
`config/deploy.rb`:

```ruby
set :linked_files, %w{
  config/database.yml
  config/secrets.yml
}
```

# Directives

* `capistrano_rails_directories` - manages `shared` and `shared/config`
* `capistrano_rails_database` - manages `shared/config/database.yml`,
* `capistrano_rails_secrets` - manages `shared/config/secrets.yml`.
* `capistrano_rails_application` - combines all of the above.

## `capistrano_rails_directories`

Manages up the base directory, `shared` and its subdirectories.

Actions:

* `:create`

Attributes:

* `base_path` - the deployment's base directory (defaults to the name of
  the directive)
* `user` - (required) the owner of the directory tree
* `group` - (required) the group owner of the directory tree
* `directory_mode` - the permissions to set on directories. Default: 0755.
* `extra_shared` - an Array of directories (along with `config`) to create
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

Manages `shared/config/database.yml`.
You must create `shared/config` beforehand.

Actions:

* `:create`

Attributes:

* `base_path` - the deployment's base directory (defaults to the name of the
  directive). Note: this is the **base** path, not the path to the
  `database.yml` file itself
* `user` - (required) the owner of the file
* `group` - (required) the group owner of the file
* `file_mode` - the permissions to set on the file. Default: 0600.
* `environment` - the Rails environment. Default: `production`
* `database` - (required) the name of the database
* `username` - (required) the database user name
* `password` - (required) the database password
* `connection_options` - a Hash of other connection options (e.g.
  `pool`, `encoding`, etc). Default: `{}`

The supplied configuration is merged into any existing file. So, multiple
`capistrano_rails_database` directives can be used for a single
deployment, as long as they are for different Rails environments.

Note: the directive does **not** manage the database itself.

## `capistrano_rails_secrets`

Manages `shared/config/secrets.yml`.

Actions:

* `:create`

Attributes:

* `base_path` - the deployment's directory (defaults to the name of the directive),
* `user` - (required) the owner of the file
* `group` - (required) the group owner of the file
* `file_mode` - the permissions to set on the file. Default: 0600.
* `environment` - the Rails environment. Default: `production`
* `secret_key_base` - (required) the application's `secret_key_base`
* `other_secrets` - a Hash of other values to include in the file.

The supplied data is used to merged into any existing file.

## `capistrano_rails_application`

Combines all of the other directives.

Actions:

* `:create`

Attributes:

Common attributes:
* `base_path` - the deployment's directory (defaults to the name of the directive),
* `user` - (required) the owner of the file
* `group` - (required) the group owner of the file
* `environment` - the Rails environment. Default: `production`
* `file_mode` - the permissions to set on files. Default: 0600.

For `capistrano_rails_directories`:
* `directory_mode` - the permissions to set on directories. Default: 0755.
* `extra_shared` - an Array of directories (along with `config`) to create

For `capistrano_rails_database`:
* `database`
* `username`
* `password`
* `connection_options`

For `capistrano_rails_secrets`
* `secret_key_base`
* `other_secrets`

Example:

```ruby
capistrano_rails_application app_base do
  user    app_user
  group   app_group
  adapter "postgresql"
  environment rails_env
  database    database_name
  password    database_password
  username    database_username
  connection_options(
    encoding: "unicode",
    pool:     5
  )
  secret_key_base app_secret_key_base
  other_secrets app_other_secrets
end
```
