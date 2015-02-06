shared_examples "when the config directory doesn't exist" do
  before do
    allow(::File).to receive(:directory?).and_call_original
    allow(::File).to receive(:directory?).with(config_path) { false }
  end

  it "fails" do
    expect do
      chef_run.converge(described_recipe)
    end.to raise_error(RuntimeError, /does not exist/)
  end
end
