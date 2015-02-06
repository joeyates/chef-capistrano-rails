# The resource should be a YAML file

require "yaml"

module YamlResource
  def create_or_update_yaml_resource(path, data, new_user, new_group, new_mode)
    resource_directory = ::File.dirname(path)
    if ! directory_exists?(resource_directory)
      if Chef::Config[:why_run]
        description = "need the resource directory '#{resource_directory}' to be created first"
        converge_by(description) {}
      else
        raise %Q(The resource's directory "#{resource_directory}" does not exist)
      end
    end

    existing = existing_data(path)
    new_content = merged_content(existing, data)

    file path do
      content new_content
      user new_user
      group new_group
      mode new_mode
    end
  end

  private

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
