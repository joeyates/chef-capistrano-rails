require "spec_helper"

describe "test::capistrano_rails_directories" do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ["capistrano_rails_directories"])
  end
  let(:base) { ::File.join("", "var", "www", "foo") }
  let(:shared) { File.join(base, "shared") }
  let(:config) { File.join(shared, "config") }
  let(:expected) do
    {
      user: "fred",
      group: "smith",
      mode: 0755,
    }
  end

  shared_examples "creates directories" do |extra = []|
    defaults = [[], %w(shared), %w(shared config)]
    extras = extra.map { |p| ["shared", p] }
    (defaults + extras).each do |p|
      it "creates '#{p.join("/")}'" do
        path = File.join("", "var", "www", "foo", *p)
        expect(chef_run).to create_directory(path).with(expected.merge(path: path))
      end
    end
  end

  before do
    chef_run.node.set["cookbook"]["name"] = base
    chef_run.node.set["cookbook"]["user"] = "fred"
    chef_run.node.set["cookbook"]["group"] = "smith"
  end

  context "supplying minimal attributes" do
    before { chef_run.converge(described_recipe) }

    context "creates directories" do
      include_examples "creates directories"
    end
  end

  context "when overriding 'mode'" do
    let(:expected) { super().merge(mode: 0700) }

    before do
      chef_run.node.set["cookbook"]["mode"] = 0700
      chef_run.converge(described_recipe)
    end

    context "creates directories" do
      include_examples "creates directories"
    end
  end

  context "when adding extra directories 'bar' and 'quux'" do
    before do
      chef_run.node.set["cookbook"]["extra"] = %w(bar quux)
      chef_run.converge(described_recipe)
    end

    context "creates directories" do
      include_examples "creates directories", %w(bar quux)
    end
  end
end
