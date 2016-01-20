module SlashCommand
  class CommandsContainer
    attr_reader :unknown, :default

    delegate :map, :each, to: :@relation

    def initialize(config)
      @cache = {}
      setup(config)
      build
    end

    def fetch(name)
      @cache.fetch(name, @unknown)
    end

    private

    def setup(config)
      @help = config.fetch(:help)
      @default = config.fetch(:default)
      @unknown = config.fetch(:unknown)

      @relation = Array(config.fetch(:available))
      @relation.concat Array(config.fetch(:example, nil)) unless Rails.env.production?
      @relation.push config.fetch(:help)
    end

    def build
      @relation.each {|command| @cache[command.name!] = command }

      @options.freeze
      @relation.freeze
    end
  end
end
