describe "test::capistrano_rails_directories" do
  let(:base_path) { ::File.join("", "var", "www", "foo") }
  let(:shared) { File.join(base_path, "shared") }
  let(:config) { File.join(shared, "config") }
  let(:expected) do
    {
      user: "fred",
      group: "smith",
      mode: 0755,
    }
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["capistrano_rails_directories"]) do |node|
      node.set["cookbook"]["name"] = base_path
      node.set["cookbook"]["user"] = "fred"
      node.set["cookbook"]["group"] = "smith"
    end
  end

  shared_examples "creates directories" do |extra_shared = []|
    defaults = [[], %w(shared), %w(shared config)]
    extras = extra_shared.map { |p| ["shared", p] }
    (defaults + extras).each do |p|
      it "creates '#{p.join("/")}'" do
        path = File.join("", "var", "www", "foo", *p)
        expect(chef_run).to create_directory(path).with(expected.merge(path: path))
      end
    end
  end

  context "supplying minimal attributes" do
    before { chef_run.converge(described_recipe) }

    context "creates directories" do
      include_examples "creates directories"
    end
  end

  context "when overriding 'directory_mode'" do
    let(:expected) { super().merge(mode: 0700) }

    before do
      chef_run.node.set["cookbook"]["directory_mode"] = 0700
      chef_run.converge(described_recipe)
    end

    context "creates directories" do
      include_examples "creates directories"
    end
  end

  context "when adding extra_shared directories 'bar' and 'quux'" do
    before do
      chef_run.node.set["cookbook"]["extra_shared"] = %w(bar quux)
      chef_run.converge(described_recipe)
    end

    context "creates directories" do
      include_examples "creates directories", %w(bar quux)
    end
  end
end
