include AttributesConverger

def whyrun_supported?
  true
end

action :create do
  user = @current_resource.user
  group = @current_resource.group
  mode = @current_resource.mode
  @current_resource.paths.each do |path|
    Chef::Log.info "path: #{path}"
    if ! ::File.directory?(path)
      create_missing_directory path
    else
      optionally_update_permissions path, mode
      optionally_update_ownership path, user, group
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::CapistranoRailsDirectories.new(
    @new_resource.name
  )
  @current_resource.name(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.mode(@new_resource.mode)

  base = @new_resource.path
  directories = [
    base,
    ::File.join(base, "shared"),
  ]
  shared = @new_resource.extra | ["config"]
  directories += shared.map { |p| ::File.join(base, "shared", p) }

  @current_resource.paths = directories
end

private

def create_missing_directory(path)
  converge_by(%Q(create directory "#{path}")) do
    resource = @current_resource
    directory path do
      user    resource.user
      group   resource.group
      mode    resource.mode
    end
  end
end
