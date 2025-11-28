(require 'rails_helper')

RSpec.describe FileBackup::Importer, type: :service do
  describe '#initialize' do
    it 'sets the import_file and initializes imported_items as an empty array' do
      json = '[{"descriptor":"D","value":"V","placement":"P"}]'
      importer = described_class.new(json)

      expect(importer.import_file).to eq(json)
      expect(importer.imported_items).to eq([])
    end
  end

  describe '#import' do
    it 'parses the JSON and returns an array of EncodedItem instances' do
      payload = [
        { descriptor: 'D1', value: 'V1', placement: 'P1' },
        { descriptor: 'D2', value: 'V2', placement: 'P2' }
      ]

      json_string = payload.to_json

      item1 = double('EncodedItem1')
      item2 = double('EncodedItem2')

      expect(EncodedItem).to receive(:new).with(hash_including('descriptor' => 'D1', 'value' => 'V1', 'placement' => 'P1')).and_return(item1)
      expect(EncodedItem).to receive(:new).with(hash_including('descriptor' => 'D2', 'value' => 'V2', 'placement' => 'P2')).and_return(item2)

      importer = described_class.new(json_string)
      result = importer.import

      expect(result).to eq([ item1, item2 ])
      expect(importer.imported_items).to eq(result)
    end
  end
end
