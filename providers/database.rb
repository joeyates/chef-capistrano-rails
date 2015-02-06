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
    @current_resource.file_mode
  )
end

def load_current_resource
  @current_resource = @new_resource.class.new(@new_resource.base_path)
  Chef::Resource::CapistranoRailsDatabase::ALL_ATTRIBUTES.each do |attr|
    @current_resource.send(attr, @new_resource.send(attr))
  end
end

private

def updating_data
  stringified = stringify_keys(@current_resource.connection_options)

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
  ::File.join(@current_resource.base_path, "shared", "config")
end

def current_resource_path
  ::File.join(resource_directory, "database.yml")
end

def stringify_keys(hash)
  hash.each.with_object({}) do |(k, v), h|
    h[k.to_s] = v
  end
end
