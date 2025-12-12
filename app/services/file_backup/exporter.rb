module FileBackup
    class Exporter
        attr_reader :items_to_export, :file_path

        def initialize(items_to_export)
            @items_to_export = items_to_export
            @file_path = apply_file_path
        end

        def export
            File.open(file_path, "w") do |file|
                file.write(items_to_export.map { |item| extract_exportable_info(item) }.to_json)
            end
        end

        private

        def extract_exportable_info(item_to_export)
            {
                descriptor: item_to_export.descriptor,
                value: item_to_export.value,
                placement: item_to_export.placement
            }
        end

        def apply_file_path
            directory = File.join(File.dirname(__FILE__), "../../../")
            @file_path = "#{directory}exports/items_export_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.json"
        end
    end
end
