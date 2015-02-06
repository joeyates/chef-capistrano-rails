require "spec_helper"

describe "test::capistrano_rails_secrets" do
  let(:base_path) { ::File.join("", "var", "www", "foo") }
  let(:config_path) { ::File.join(base_path, "shared", "config") }
  let(:config_exists) { true }
  let(:user) { "user" }
  let(:group) { "group" }
  let(:secret_key_base) { "secret_key_base" }
  let(:path) { File.join(base_path, "shared", "config", "secrets.yml") }
  let(:environment) { "production" }
  let(:expected_data) do
    {environment => {"secret_key_base" => secret_key_base}}
  end
  let(:expected_content) { yaml_without_separator(expected_data) }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["capistrano_rails_secrets"]) do |node|
      node.set["cookbook"]["name"] = base_path
      node.set["cookbook"]["user"] = user
      node.set["cookbook"]["group"] = group
      node.set["cookbook"]["secret_key_base"] = secret_key_base
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

  context "with other_secrets" do
    let(:other_secrets) { {"foo" => "bar"} }
    let(:expected_data) do
      data = super()
      data[environment].merge!(other_secrets)
      data
    end

    before do
      chef_run.node.set["cookbook"]["other_secrets"] = other_secrets
      chef_run.converge(described_recipe)
    end

    it "saves the file" do
      expect(chef_run).to create_file(path).with(content: expected_content)
    end

    context "with symbol keys" do
      let(:other_secrets) { {foo: "bar"} }
      let(:expected_data) do
        data = super()
        data[environment]["foo"] = data[environment].delete(:foo)
        data
      end

      it "converts symbols to strings" do
        expect(chef_run).to create_file(path).with(content: expected_content)
      end
    end
  end

  context "when setting the environment" do
    let(:environment) { "an_env" }

    before do
      chef_run.node.set["cookbook"]["environment"] = environment
      chef_run.converge(described_recipe)
    end

    it "saves the file" do
      expect(chef_run).to create_file(path).with(content: expected_content)
    end

    context "with other environments" do
      include_examples "with other environments"
    end
  end

  context "when the config directory doesn't exist" do
    include_examples "when the config directory doesn't exist"
  end
end
