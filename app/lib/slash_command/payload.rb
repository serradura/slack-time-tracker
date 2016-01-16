module SlashCommand
  class Payload
    User = Struct.new(:name, :id)

    attr_reader :raw, :user

    delegate :command, :data, to: :@arguments

    def initialize(params)
      @raw  = params
      @user = User.new(raw[:user_name], raw[:user_id])
      @arguments = ArgumentsParser.new(params[:text])
    end

    def token
      @raw[:token]
    end

    def valid?
      PayloadValidator.new(self).valid?
    end
  end
end
