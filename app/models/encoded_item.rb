class EncodedItem < ApplicationRecord
    PLACEMENT_MIN = 0
    PLACEMENT_MAX = 9
    CYCLE_MIN = 2
    CYCLE_MAX = 10
    MAIN_DESCRIPTOR = 'MAIN ENCODED ITEM'

    before_create :apply_encoding_for_create

    scope :with_main_descriptor, lambda {
        where(descriptor: MAIN_DESCRIPTOR)
    }

    def self.does_main_item_exist?
        with_main_descriptor.exists?
    end

    def decode_value
        parsed_placement = decode_placement.to_i
        cycles = self.value[parsed_placement].to_i
        decoded_value = self.value

        apply_base64_in_cycles(
            cycles,
            decoded_value[0, parsed_placement] + decoded_value[parsed_placement + 1, decoded_value.length],
            :decode64
        )
    end

    def decode_placement
        Base64.decode64(self.placement)
    end

    private

    def apply_encoding_for_create
        unencoded_placement = rand(PLACEMENT_MIN..PLACEMENT_MAX)
        cycles = rand(CYCLE_MIN..CYCLE_MAX)
        self.value = apply_base64_in_cycles(cycles, self.value, :encode64)
        self.value.insert(unencoded_placement, cycles.to_s)
        self.placement = Base64.encode64(unencoded_placement.to_s)
    end

    def apply_base64_in_cycles(cycles, apply_to, base64_method)
        result = apply_to
        (0...cycles).each do |cycle|
            result = Base64.send(base64_method, result)
        end

        result
    end
end
