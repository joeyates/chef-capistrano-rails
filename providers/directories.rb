def whyrun_supported?
  true
end

action :create do
  @current_resource.paths.each do |path|
    resource = @current_resource
    directory path do
      user resource.user
      group resource.group
      mode resource.mode
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
  shared = @new_resource.extra_shared | ["config"]
  directories += shared.map { |p| ::File.join(base, "shared", p) }

  @current_resource.paths = directories
end
