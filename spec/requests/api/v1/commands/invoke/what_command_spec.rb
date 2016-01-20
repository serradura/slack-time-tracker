require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:current_command) { SlashCommand::Commands::What }

  describe "'what' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) { create(:slack_payload).tap {|pay| pay.text = "what" } }

    it "responds with the event lectures" do
      first_lecture_url  = "http://hey.wearestac.com/lectures/a-pint-with-the-pub-landlord"
      second_lecture_url = "http://hey.wearestac.com/lectures/kickstarting-a-city-wide-food-festival"

      expect(response).to have_http_status(200)
      expect(response.body).to include first_lecture_url
      expect(response.body).to include second_lecture_url
    end

    context "help" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "help what" }
      end

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
