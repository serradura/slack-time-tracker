# frozen_string_literal: true

module TimeEntries
  LINE_BREAK = "\n"

  class Body
    def self.map(relation, data)
      relation
        .map {|time_entry| Row.new(time_entry, data).build }
        .join(LINE_BREAK)
    end
  end
end
