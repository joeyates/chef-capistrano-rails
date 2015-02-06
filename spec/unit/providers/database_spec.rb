require "spec_helper"

describe "test::capistrano_rails_database" do
  let(:base_path) { ::File.join("", "var", "www", "foo") }
  let(:config_path) { ::File.join(base_path, "shared", "config") }
  let(:config_exists) { true }
  let(:user) { "user" }
  let(:group) { "group" }
  let(:adapter) { "an_adapter" }
  let(:database) { "the_database" }
  let(:username) { "a_username" }
  let(:password) { "a_password" }
  let(:path) { File.join(base_path, "shared", "config", "database.yml") }
  let(:environment) { "production" }
  let(:expected_data) do
    {
      environment => {
        "adapter" => adapter,
        "database" => database,
        "username" => username,
        "password" => password,
      }
    }
  end
  let(:expected_content) { yaml_without_separator(expected_data) }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["capistrano_rails_database"]) do |node|
      node.set["cookbook"]["name"] = base_path
      node.set["cookbook"]["user"] = user
      node.set["cookbook"]["group"] = group
      node.set["cookbook"]["adapter"] = adapter
      node.set["cookbook"]["database"] = database
      node.set["cookbook"]["username"] = username
      node.set["cookbook"]["password"] = password
    end
  end

  before do
    allow(::File).to receive(:directory?).and_call_original
    allow(::File).to receive(:directory?).with(config_path) { config_exists }
  end

  context "supplying minimal attributes" do
    before { chef_run.converge(described_recipe) }

    it "saves the file" do
      expect(chef_run).to create_file(path).with(
        content: expected_content,
        name: path,
        user: user,
        group: group,
      )
    end

    it "sets restrictive permissions" do
      expect(chef_run).to create_file(path).with(mode: 0600)
    end
  end

  context "when setting the environment" do
    let(:environment) { "an_env" }

    before do
      chef_run.node.set["cookbook"]["environment"] = environment
      chef_run.converge(described_recipe)
    end

    it "saves the file" do
      expect(chef_run).to create_file(path).with(
        content: expected_content,
      )
    end

    context "with other environments" do
      include_examples "with other environments"
    end
  end

  context "with connection_options" do
    let(:connection_options) { {"foo" => "bar"} }
    let(:expected_data) do
      data = super()
      data[environment].merge!(connection_options)
      data
    end

    before do
      chef_run.node.set["cookbook"]["connection_options"] = connection_options
      chef_run.converge(described_recipe)
    end

    it "merges in the options" do
      expect(chef_run).to create_file(path).with(content: expected_content)
    end
  end
end
