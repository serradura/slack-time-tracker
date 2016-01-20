# frozen_string_literal: true

module SlashCommand
  module Commands
    class Help < Template
      CACHE = {help: nil}

      delegate :commands, :name!, to: :class

      NAME = "help"
      DESC = "Display help information about \"/tt\""

      def self.commands
        Invoke.commands
      end

      def self.help
        CACHE[:help] ||= "Available commands:\n#{list}".freeze
      end

      def self.list
        commands
          .map {|command| "#{command.name!}\t|\t#{command.description}" }
          .join("\n")
          .tap(&:strip!)
      end
      private_class_method :list

      def call
        response.result = fetch_command.help
      end

      private

      def fetch_command
        help_command? ? self.class : commands.fetch_by_name(data.downcase)
      end

      def help_command?
        name == name! && data.blank?
      end
    end
  end
end
