module TimeEntries
  class BaseRow
    IDS_PATTERN = /(-i|(--|—)ids)/.freeze

    def ids?
      @data =~ IDS_PATTERN
    end

    def last_col(value)
      "\t#{value}"
    end

    def col(value)
      "\t#{value}\t|"
    end

    def text
      row = "#{col(date)}#{col(start_time)}#{col(end_time)}#{col(duration)}#{last_col(note)}"

      ids? ? "#{col(id)}#{row}" : row
    end

    def build
      text.tap(&:strip!)
    end
  end
end
