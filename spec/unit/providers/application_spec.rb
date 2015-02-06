describe "test::capistrano_rails_application" do
  let(:base_path) { ::File.join("", "var", "www", "foo") }
  let(:user) { "user" }
  let(:group) { "group" }
  let(:adapter) { "adapter" }
  let(:database) { "database" }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:secret_key_base) { "secret_key_base" }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["capistrano_rails_application"]) do |node|
      node.set["cookbook"]["name"] = base_path
      node.set["cookbook"]["user"] = user
      node.set["cookbook"]["group"] = group
      node.set["cookbook"]["adapter"] = adapter
      node.set["cookbook"]["database"] = database
      node.set["cookbook"]["username"] = username
      node.set["cookbook"]["password"] = password
      node.set["cookbook"]["secret_key_base"] = secret_key_base
    end
  end

  context "with required attributes" do
    before do
      chef_run.converge(described_recipe)
    end

    context "directories" do
      it "are created" do
        expect(chef_run).to create_capistrano_rails_directories(base_path).with(
          user: user,
          group: group,
        )
      end

      it "have permissions set to 0755 by default" do
        expect(chef_run).to create_capistrano_rails_directories(base_path).with(
          directory_mode: 0755
        )
      end
    end

    context "database.yml" do
      it "is created" do
        expect(chef_run).to create_capistrano_rails_database(base_path).with(
          user: user,
          group: group,
          adapter: adapter,
          database: database,
          username: username,
          password: password,
        )
      end

      it "has permissions set to 0600 by default" do
        expect(chef_run).to create_capistrano_rails_database(base_path).with(
          file_mode: 0600
        )
      end
    end

    context "secrets.yml" do
      it "is created" do
        expect(chef_run).to create_capistrano_rails_secrets(base_path).with(
          user: user,
          group: group,
          secret_key_base: secret_key_base,
        )
      end

      it "has permissions set to 0600 by default" do
        expect(chef_run).to create_capistrano_rails_secrets(base_path).with(
          file_mode: 0600
        )
      end
    end
  end

  context "when directory_mode is set" do
    before do
      chef_run.node.set["cookbook"]["directory_mode"] = 0750
      chef_run.converge(described_recipe)
    end

    it "passes it to directories" do
      expect(chef_run).to create_capistrano_rails_directories(base_path).with(
        directory_mode: 0750
      )
    end
  end
end
