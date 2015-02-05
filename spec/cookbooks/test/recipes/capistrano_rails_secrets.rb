capistrano_rails_secrets node["cookbook"]["name"] do
  node["cookbook"].each_pair do |attr, val|
    send(attr.intern, val)
  end
end
