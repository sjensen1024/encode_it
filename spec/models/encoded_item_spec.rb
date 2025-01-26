require 'rails_helper'

RSpec.describe EncodedItem, type: :model do
  
  context 'what we expect to happen on create' do
    let(:encoded_item) do 
      EncodedItem.create(descriptor: 'Phrase', value: 'Hello world!' )
    end

    it 'should have a descriptor of Phrase' do
      expect(encoded_item.descriptor).to eq('Phrase')  
    end

    it 'should set the value to the encoded version of Hello world!' do
      encoded_value = Base64.encode64('Hello world!')
      expect(encoded_item.value).to eq(encoded_value)
    end
  end
end
