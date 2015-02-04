# The resource should be a YAML file

# Including providers must supply the following:
# * path - the path to the YAML file
# * data - the data to be merged into the file
# * user, group and mode

require "etc"
require "yaml"

module YamlResource
  include AttributesConverger

  def create_or_update_yaml_resource(path, data, user, group, mode)
    resource_directory = ::File.dirname(path)
    if ! directory_exists?(resource_directory)
      if Chef::Config[:why_run]
        description = "need the resource directory '#{resource_directory}' to be created first"
        converge_by(description) {}
      else
        raise %Q(The resource's directory "#{resource_directory}" does not exist)
      end
    end

    if ::File.exist?(path)
      optionally_update_permissions path, mode
      optionally_update_ownership path, user, group
    end

    optionally_update_file path, data, user, group, mode
  end

  private

  def optionally_update_file(path, data, user, group, mode)
    existing = existing_data(path)
    new_content = merged_content(existing, data)

    yaml_diff = DiffableResource.create_diff(path, new_content)
    return if yaml_diff.nil?

    description =
      if ::File.exist?(path)
        %Q(update "#{path}")
      else
        %Q(create "#{path}")
      end

    description << "\n"
    description << yaml_diff
    converge_by(description) do
      write_file(path, new_content, user, group, mode)
    end
  end

  def write_file(path, content, user, group, mode)
    ::File.open(path, "w") do |f|
      f.write content
    end
    update_permissions path, mode
    update_ownership path, user, group
  end

  def existing_data(path)
    if ::File.exist?(path)
      content = ::File.read(path)
      parsed = YAML.parse(content)
      if parsed
        parsed.to_ruby
      else
        {}
      end
    else
      {}
    end
  end

  def merged_content(existing_data, new_data)
    content_from(existing_data.merge(new_data))
  end

  def content_from(data)
    content = data.to_yaml
    content.sub(/^\-+\n/, '')
  end

  def directory_exists?(directory_path)
    ::File.directory?(directory_path)
  end
end
