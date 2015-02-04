if defined?(ChefSpec)
  def create_capistrano_rails_directories(path)
    ChefSpec::Matchers::ResourceMatcher.new(
      :capistrano_rails_directories, :create, path
    )
  end
end
