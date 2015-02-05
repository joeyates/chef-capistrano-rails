require "spec_helper"

describe "test::capistrano_rails_secrets" do
  def yaml_without_separator(data)
    s = data.to_yaml
    s.sub(/^\-+\n/, '')
  end

  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ["capistrano_rails_secrets"])
  end
  let(:base) { ::File.join("", "var", "www", "foo") }
  let(:config_path) { ::File.join(base, "shared", "config") }
  let(:config_exists) { true }
  let(:user) { "user" }
  let(:group) { "group" }
  let(:secret_key_base) { "secret_key_base" }
  let(:secrets_yml) { File.join(base, "shared", "config", "secrets.yml") }
  let(:expected_content) { yaml_without_separator(expected_data) }
  let(:expected_data) do
    {"production" => {"secret_key_base" => secret_key_base}}
  end

  before do
    allow(::File).to receive(:directory?).and_call_original
    allow(::File).to receive(:directory?).with(config_path) { config_exists }
    chef_run.node.set["cookbook"]["name"] = base
    chef_run.node.set["cookbook"]["user"] = user
    chef_run.node.set["cookbook"]["group"] = group
    chef_run.node.set["cookbook"]["secret_key_base"] = secret_key_base
  end

  context "supplying minimal attributes" do
    before { chef_run.converge(described_recipe) }

    it "saves the file" do
      expect(chef_run).to create_file(secrets_yml).with(
        content: expected_content,
        name: secrets_yml,
        user: user,
        group: group,
      )
    end

    it "sets restrictive permissions" do
      expect(chef_run).to create_file(secrets_yml).with(mode: 0600)
    end
  end

  context "with other_secrets" do
    let(:other_secrets) { {"foo" => "bar"} }
    let(:expected_data) do
      {
        "production" => {
          "secret_key_base" => secret_key_base
        }.merge(other_secrets)
      }
    end

    before do
      chef_run.node.set["cookbook"]["other_secrets"] = other_secrets
      chef_run.converge(described_recipe)
    end

    it "saves the file" do
      expect(chef_run).to create_file(secrets_yml).with(
        content: expected_content,
      )
    end

    context "with symbol keys" do
      let(:other_secrets) { {foo: "bar"} }
      let(:expected_data) do
        data = super()
        data["production"]["foo"] = data["production"].delete(:foo)
        data
      end

      it "converts symbols to strings" do
        expect(chef_run).to create_file(secrets_yml).with(
          content: expected_content,
        )
      end
    end
  end

  context "with environment" do
    let(:environment) { "ciao" }
    let(:expected_data) do
      {environment => {"secret_key_base" => secret_key_base}}
    end

    before do
      chef_run.node.set["cookbook"]["environment"] = environment
      chef_run.converge(described_recipe)
    end

    it "saves the file" do
      expect(chef_run).to create_file(secrets_yml).with(
        content: expected_content,
      )
    end
  end

  context "when the config directory doesn't exists" do
    let(:config_exists) { false }

    it "fails" do
      expect do
        chef_run.converge(described_recipe)
      end.to raise_error(RuntimeError, /does not exist/)
    end
  end
end
