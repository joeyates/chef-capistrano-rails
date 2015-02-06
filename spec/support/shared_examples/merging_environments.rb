shared_examples "with other environments" do
  let(:merged_data) { original_data.merge(expected_data) }
  let(:merged_content) { yaml_without_separator(merged_data) }
  let(:original_data) { {"foo" => {"bar" => "baz"}} }
  let(:original_content) { yaml_without_separator(original_data) }

  before do
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with(path) { true }
    allow(::File).to receive(:read).with(path) { original_content }
    chef_run.node.set["cookbook"]["environment"] = environment
    chef_run.converge(described_recipe)
  end

  it "merges the new data" do
    expect(chef_run).to create_file(path).with(
      content: merged_content
    )
  end
end
