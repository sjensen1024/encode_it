require 'rails_helper'

RSpec.describe EncodedItem, type: :model do
  context 'testing the factory' do
    it_behaves_like "factory defaults for building and creating succeed for factory type", :encoded_item
  end


  let(:encoded_item) do
    FactoryBot.create(:encoded_item, descriptor: 'Phrase', value: 'Hello world!')
  end

  context 'creating and decoding' do
    (EncodedItem::PLACEMENT_MIN...EncodedItem::PLACEMENT_MAX).each do |stub_rand_placement|
      (EncodedItem::CYCLE_MIN...EncodedItem::CYCLE_MAX).each do |stub_rand_cycle|
        context "unencoded placement is #{stub_rand_placement}, unencoded cycle is #{stub_rand_cycle}" do
          before do
            allow_any_instance_of(EncodedItem).to receive(:rand).with(
              EncodedItem::PLACEMENT_MIN..EncodedItem::PLACEMENT_MAX
            ).and_return(stub_rand_placement)

            allow_any_instance_of(EncodedItem).to receive(:rand).with(
              EncodedItem::CYCLE_MIN..EncodedItem::CYCLE_MAX
            ).and_return(stub_rand_cycle)
          end

          let(:expected_encoded_value) do
            expected_value = 'Hello world!'
            (0...stub_rand_cycle).each do
              expected_value = Base64.encode64(expected_value)
            end
            expected_value.insert(stub_rand_placement, stub_rand_cycle.to_s)
          end

          it 'should have a descriptor of Phrase' do
            expect(encoded_item.descriptor).to eq('Phrase')
          end

          it "placement should be an encoded version of #{stub_rand_placement}" do
            expect(encoded_item.placement).to eq(Base64.encode64(stub_rand_placement.to_s))
          end

          it 'value should be an even more encoded version of "Hello world!" with cycles injected at the index of placement' do
            expect(encoded_item.value).not_to include('Hello world!')
            expect(encoded_item.value).to eq(expected_encoded_value)
          end

          it 'should return "Hello world!" when we call decode_value WITHOUT changing the actual saved value' do
            expect(encoded_item.decode_value).to eq('Hello world!')
            expect(encoded_item.value).to eq(expected_encoded_value)
          end
        end
      end
    end
  end

  context 'does_main_item_exist?' do
  end
end
