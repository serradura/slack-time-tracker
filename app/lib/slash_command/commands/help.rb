# frozen_string_literal: true

module SlashCommand
  module Commands
    class Help < Template
      HELP = {cache: nil}

      def self.description
        "Display help information about \"/tt\"".freeze
      end

      def call
        response.result = result
      end

      def result
        HELP[:cache] ||= "Available commands:\n#{commands_help}".freeze
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
