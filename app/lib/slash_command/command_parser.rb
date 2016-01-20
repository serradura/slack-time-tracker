# frozen_string_literal: true

module SlashCommand
  class CommandParser
    EMPTY_SPACE = " "
    ANY_SPACE_PATTERN = /\s+/.freeze

    attr_reader :text

    def initialize(text)
      normalize(text)
      parse
    end

    def blank?
      name.blank? && data.blank?
    end

    def name
      @name ||= @raw_name.tap(&:downcase!)
    end

    def data
      @data ||= @raw_data.join(EMPTY_SPACE)
    end

    private

    def normalize(text)
      @text = String(text).tap do |str|
        str.strip!
        str.gsub!(ANY_SPACE_PATTERN, EMPTY_SPACE)
      end
    end

    def parse
      @raw_data = Array(@text.split)
      @raw_name = String(@raw_data.shift)
    end
  end
end
