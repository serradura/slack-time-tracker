# frozen_string_literal: true

module SlashCommand
  module Commands
    class Help < Template
      CACHE = {data: nil}

      DESC = "Display help information about \"/tt\""

      def call
        response.result = result
      end

      def result
        CACHE[:data] ||= "Available commands:\n#{commands_help}".freeze
      end

      def commands_help
        SlashCommand::Invoke::COMMANDS
          .map {|name, command| "#{name}\t|\t#{command.description}" }
          .join("\n")
          .strip
      end
    end
  end
end
