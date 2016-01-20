# frozen_string_literal: true

module SlashCommand
  module Commands
    class Help < Template
      CACHE = {help: nil}

      NAME = "help"
      DESC = "Display help information about \"/tt\""

      def self.help
        CACHE[:help] ||= "Available commands:\n#{list}".freeze
      end

      def self.commands
        SlashCommand::Invoke.commands
      end

      def self.list
        commands
          .map {|command| "#{command.name!}\t|\t#{command.description}" }
          .join("\n")
          .tap(&:strip!)
      end
      private_class_method :list

      def call
        command = help_command? ? self.class : commands.fetch(data.downcase)

        response.result = command.help
      end

      private

      def help_command?
        name == self.class.name! && data.blank?
      end

      def commands
        self.class.commands
      end
    end
  end
end
