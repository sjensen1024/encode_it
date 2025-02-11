shared_examples "factory defaults for building and creating succeed for factory type" do |factory_type|
    it "should NOT raise any errors on default FactoryBot.build" do
        expect { FactoryBot.build(factory_type) }.not_to raise_error
    end
    it "should NOT raise any errors on default FactoryBot.create" do
        expect { FactoryBot.build(factory_type) }.not_to raise_error
    end
end
