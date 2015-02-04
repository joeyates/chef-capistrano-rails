include YamlResource

def whyrun_supported?
  true
end

action :create do
  create_or_update_yaml_resource(
    current_resource_path,
    updating_data,
    @current_resource.user,
    @current_resource.group,
    @current_resource.mode
  )
end

def load_current_resource
  @current_resource = Chef::Resource::CapistranoRailsDatabase.new(
    @new_resource.directory
  )
  @current_resource.directory(@new_resource.directory)
  @current_resource.adapter(@new_resource.adapter)
  @current_resource.database(@new_resource.database)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.mode(@new_resource.mode)
  @current_resource.username(@new_resource.username)
  @current_resource.password(@new_resource.password)
  @current_resource.environment(@new_resource.environment)
  @current_resource.options(@new_resource.options)
end

def updating_data
  stringified = @current_resource.options.each.with_object({}) do |(k, v), h|
    h[k.to_s] = v
  end
  {
    @current_resource.environment => {
      "adapter" => @current_resource.adapter,
      "database" => @current_resource.database,
      "username" => @current_resource.username,
      "password" => @current_resource.password,
    }.merge(stringified)
  }
end

def resource_directory
  ::File.join(@current_resource.directory, "shared", "config")
end

def current_resource_path
  ::File.join(resource_directory, "database.yml")
end
