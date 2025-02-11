FactoryBot.define do
    factory :encoded_item do
        descriptor { Forgery("basic").text }
        value { Forgery("basic").text }
    end
end