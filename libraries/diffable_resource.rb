require "chef/util/diff"

module DiffableResource
  def self.create_diff(path, new_content)
    diff = Chef::Util::Diff.new

    current = current_file(path)
    tempfile = tempfile_with(new_content)

    diff.diff(current, tempfile)

    current.close

    tempfile.close
    tempfile.unlink

    d = diff.for_reporting
    if d.nil?
      nil
    else
      d.gsub("\\n", "\n")
    end
  end

  def self.current_file(path)
    if ::File.exist?(path)
      ::File.open(path)
    else
      ::File.open("/dev/null")
    end
  end

  def self.tempfile_with(content)
    tempfile = Tempfile.new("capistrano-rails-new-file")
    tempfile.write content
    tempfile.flush
    tempfile
  end
end
