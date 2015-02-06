if defined?(ChefSpec)
  def create_capistrano_rails_directories(base_path)
    ChefSpec::Matchers::ResourceMatcher.new(
      :capistrano_rails_directories, :create, base_path
    )
  end

  def create_capistrano_rails_database(base_path)
    ChefSpec::Matchers::ResourceMatcher.new(
      :capistrano_rails_database, :create, base_path
    )
  end

  def create_capistrano_rails_secrets(base_path)
    ChefSpec::Matchers::ResourceMatcher.new(
      :capistrano_rails_secrets, :create, base_path
    )
  end

  def create_capistrano_rails_application(base_path)
    ChefSpec::Matchers::ResourceMatcher.new(
      :capistrano_rails_application, :create, base_path
    )
  end
end
