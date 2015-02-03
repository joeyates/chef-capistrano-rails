include YamlResource

def whyrun_supported?
  true
end

action :create do
  create_or_update_yaml_resource(
    current_resource_path,
    new_data,
    @current_resource.user,
    @current_resource.group,
    @current_resource.mode,
    true
  )
end

def load_current_resource
  @current_resource = Chef::Resource::CapistranoRailsSecrets.new(
    @new_resource.directory
  )
  @current_resource.directory(@new_resource.directory)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.mode(@new_resource.mode)
  @current_resource.secret_key_base(@new_resource.secret_key_base)
  @current_resource.other_secrets(@new_resource.other_secrets)
end

def new_data
  {
    "secret_key_base" => @current_resource.secret_key_base,
  }.merge(@current_resource.other_secrets)
end

def resource_directory
  ::File.join(@current_resource.directory, "shared", "config")
end

def current_resource_path
  ::File.join(resource_directory, "secrets.yml")
end
