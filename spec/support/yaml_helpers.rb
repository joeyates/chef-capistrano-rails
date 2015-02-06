def yaml_without_separator(data)
  s = data.to_yaml
  s.sub(/^\-+\n/, "")
end
