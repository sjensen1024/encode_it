module FileBackup
    class Importer
        attr_reader :import_file, :imported_items

        def initialize(import_file)
            @import_file = import_file
            @imported_items = []
        end

        def import
            results = JSON.parse(@import_file)
            @imported_items = results.map { |result| EncodedItem.new(result) }
        end

      # TODO: Add capability for saving imported items to DB.
    end
end
