# frozen_string_literal: true

module TimeEntries
  class Header < BaseRow
    def initialize(data)
      @data = data
    end

    def id
      "ID"
    end

    def date
      "Date"
    end

    def start_time
      "Start"
    end

    def end_time
      "End"
    end

    def duration
      "Duration"
    end

    def note
      "Note"
    end
  end
end
