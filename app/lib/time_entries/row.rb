module TimeEntries
  class Row < BaseRow
    TIME_FORMAT = "%H:%M:%S".freeze

    delegate :note, :id, to: :@time_entry

    def initialize(time_entry, data)
      @data = data
      @time_entry = time_entry
      @current_time = Time.current
    end

    def date
      @time_entry.date.to_formatted_s(:short)
    end

    def start_time
      format_time @time_entry.start
    end

    def end_time
      time = @time_entry.end || @current_time
      format_time time
    end

    def duration
      seconds = @time_entry.duration

      seconds.present? ? TimeDiffer.diff(seconds) : TimeDiffer.between(@time_entry.start, @current_time)
    end

    private

    def format_time(time)
      time.strftime(TIME_FORMAT)
    end
  end
end
