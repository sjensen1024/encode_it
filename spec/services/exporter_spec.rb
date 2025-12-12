require 'rails_helper'
require 'json'

RSpec.describe FileBackup::Exporter, type: :service do
  let(:fixed_time) { Time.new(2020, 1, 1, 12, 0, 0) }

  before do
    allow(Time).to receive(:now).and_return(fixed_time)
  end

  after do
    # cleanup any file we created
    if defined?(exporter) && exporter.file_path && File.exist?(exporter.file_path)
      File.delete(exporter.file_path)
    end
  end

  describe '#initialize' do
    it 'sets items_to_export and builds a file_path using the current time' do
      items = []
      exporter = described_class.new(items)

      expect(exporter.items_to_export).to eq(items)
      expect(exporter.file_path).to include('items_export_2020-01-01-12-00-00.json')
    end
  end

  describe '#export' do
    it 'writes the exported items as JSON to the file_path' do
      item_struct = Struct.new(:descriptor, :value, :placement)
      items = [ item_struct.new('D1', 'V1', 'P1'), item_struct.new('D2', 'V2', 'P2') ]

      exporter = described_class.new(items)

      exporter.export

      expect(File).to exist(exporter.file_path)

      content = File.read(exporter.file_path)
      parsed = JSON.parse(content)

      expect(parsed).to be_an(Array)
      expect(parsed.size).to eq(2)
      expect(parsed.first).to include('descriptor' => 'D1', 'value' => 'V1', 'placement' => 'P1')
      expect(parsed.last).to include('descriptor' => 'D2', 'value' => 'V2', 'placement' => 'P2')
    end
  end
end
