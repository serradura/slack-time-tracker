# frozen_string_literal: true

module SlashCommand
  class ArgumentsParser
    EMPTY_SPACE = " "
    ANY_SPACE_PATTERN = /\s+/.freeze

    attr_reader :raw

    def initialize(text)
      @raw = String(text).tap do |str|
        str.strip!
        str.gsub!(ANY_SPACE_PATTERN, EMPTY_SPACE)
      end
    end

    def command
      @command ||= get(0).tap(&:downcase!)
    end

    def data
      get(1)
    end

    private

    def parsed
      @parsed ||= @raw.split
    end

    def get(index)
      String(parsed[index])
    end
  end
end
