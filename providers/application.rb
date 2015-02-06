def whyrun_supported?
  true
end

action :create do
  resource = @current_resource
  capistrano_rails_directories resource.base_path do
    Chef::Resource::CapistranoRailsDirectories::ALL_ATTRIBUTES.each do |attr|
      send(attr, resource.send(attr))
    end
  end

  capistrano_rails_database resource.base_path do
    Chef::Resource::CapistranoRailsDatabase::ALL_ATTRIBUTES.each do |attr|
      send(attr, resource.send(attr))
    end
  end

  capistrano_rails_secrets resource.base_path do
    Chef::Resource::CapistranoRailsSecrets::ALL_ATTRIBUTES.each do |attr|
      send(attr, resource.send(attr))
    end
  end
end

def load_current_resource
  @current_resource = @new_resource.class.new(@new_resource.base_path)
  attributes =
    Chef::Resource::CapistranoRailsDirectories::ALL_ATTRIBUTES +
    Chef::Resource::CapistranoRailsDatabase::ALL_ATTRIBUTES +
    Chef::Resource::CapistranoRailsSecrets::ALL_ATTRIBUTES
  attributes.each do |attr|
    @current_resource.send(attr, @new_resource.send(attr))
  end
end
