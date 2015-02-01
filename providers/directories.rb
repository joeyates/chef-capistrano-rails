def whyrun_supported?
  true
end

action :create do
  @current_resource.paths.each do |p, exists|
    if exists
      Chef::Log.info "Directory #{p} already exists - nothing to do."
    else
      converge_by(%Q(create directory "#{p}")) do
        directory p do
          user    new_resource.user
          group   new_resource.group
          mode    new_resource.mode
        end
      end
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::CapistranoRailsDirectories.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.mode(@new_resource.mode)

  @current_resource.paths = {
    @new_resource.path => nil,
    ::File.join(@new_resource.path, "shared") => nil,
  }

  @current_resource.paths.keys.each do |p|
    @current_resource.paths[p] = ::File.directory?(p)
  end
end
