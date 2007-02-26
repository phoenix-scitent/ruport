module Ruport::Format

  # This plugin implements the CSV format for tabular data output. 
  # See also:  Renderer::Table
  class CSV < Plugin
    # Generates table header by turning column_names into a CSV row.
    # Uses the row renderer to generate the actual formatted output
    #
    # This method does not do anything if options.show_table_headers is false
    # or the Data::Table has no column names.
    def build_table_header
      unless data.column_names.empty? || !options.show_table_headers
        Ruport::Renderer::Row.render_csv data.column_names, :io => output,
          :format_options => options.format_options 
      end
    end

    # Calls the row renderer for each row in the Data::Table
    def build_table_body
      render_data_by_row { |r| 
        r.options.format_options = options.format_options
      }
    end

    # Produces CSV output for a data row.
    def build_row
      require "fastercsv"
      FCSV(output,options.format_options || {}) { |csv| 
        csv << data
      }
    end
  end
end
