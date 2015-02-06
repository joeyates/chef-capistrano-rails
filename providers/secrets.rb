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
  Chef::Resource::CapistranoRailsSecrets::ALL_ATTRIBUTES.each do |attr|
    @current_resource.send(attr, @new_resource.send(attr))
  end
end

private

def updating_data
  {
    @current_resource.environment => {
      "secret_key_base" => @current_resource.secret_key_base,
    }.merge(@current_resource.other_secrets)
  }
end

def resource_directory
  ::File.join(@current_resource.base_path, "shared", "config")
end

def current_resource_path
  ::File.join(resource_directory, "secrets.yml")
end
