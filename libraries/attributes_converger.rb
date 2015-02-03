module AttributesConverger
  def optionally_update_permissions(path, new_mode)
    stat = ::File.stat(path)
    mode = stat.mode & 0777
    if mode != new_mode
      description = %Q(update "#{path}" permissions to %04o) % new_mode
      converge_by(description) do
        update_permissions new_mode, path
      end
    end
  end

  def optionally_update_ownership(path, new_user, new_group)
    stat = ::File.stat(path)
    current_user = ::Etc.getpwuid(stat.uid).name
    current_group = ::Etc.getgrgid(stat.gid).name
    if current_user != new_user || current_group != new_group
      description = %Q(update "#{path}" owner to "#{new_user}" and group to "#{new_group}")
      converge_by(description) do
        update_ownership path, new_user, new_group
      end
    end
  end

  def update_permissions(path, mode)
    ::File.chmod mode, path
  end

  def update_ownership(path, user, group)
    uid = ::Etc.getpwnam(user).uid
    gid = ::Etc.getgrnam(group).gid
    ::File.chown uid, gid, path
  end
end
