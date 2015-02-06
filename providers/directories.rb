def whyrun_supported?
  true
end

action :create do
  @current_resource.paths.each do |path|
    resource = @current_resource
    directory path do
      user resource.user
      group resource.group
      mode resource.directory_mode
    end
  end
end

def load_current_resource
  @current_resource = @new_resource.class.new(@new_resource.base_path)
  Chef::Resource::CapistranoRailsDirectories::ALL_ATTRIBUTES.each do |attr|
    @current_resource.send(attr, @new_resource.send(attr))
  end

  build_directory_list
end

private

def build_directory_list
  base = @new_resource.base_path
  directories = [
    base,
    ::File.join(base, "shared"),
  ]
  shared = @new_resource.extra_shared | ["config"]
  directories += shared.map { |p| ::File.join(base, "shared", p) }

  @current_resource.paths = directories
end
