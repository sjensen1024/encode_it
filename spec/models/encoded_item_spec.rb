require 'rails_helper'

RSpec.describe EncodedItem, type: :model do
  let(:encoded_item) do
    EncodedItem.create(descriptor: 'Phrase', value: 'Hello world!')
  end

  context 'what we expect to happen on create' do
    it 'should have a descriptor of Phrase' do
      expect(encoded_item.descriptor).to eq('Phrase')
    end

    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].each do |integer|
      it "when rand returns #{integer}, it should set placement to an encoded version of #{integer}" do
        allow_any_instance_of(EncodedItem).to receive(:rand).and_return(integer)
        expect(encoded_item.placement).to eq(Base64.encode64(integer.to_s))
      end
    end

    it 'should set the value to the encoded version of Hello world!' do
      encoded_value = Base64.encode64('Hello world!')
      expect(encoded_item.value).to eq(encoded_value)
    end
  end

  describe :decode_value do
    it 'should get the decoded version of the value' do
      expect(encoded_item.decode_value).to eq('Hello world!')
    end
  end
end
