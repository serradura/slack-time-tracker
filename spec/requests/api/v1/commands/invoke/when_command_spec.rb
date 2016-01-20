require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:current_command) { SlashCommand::Commands::When }

  describe "'when' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) do
      create(:slack_payload).tap {|pay| pay.text = "when" }
    end

    it "responds with the event location" do
      user_reference = "Hopefully see you then #{payload.user_name}"
      expected_url   = "http://hey.wearestac.com/"

      expect(response).to have_http_status(200)
      expect(response.body).to include user_reference
      expect(response.body).to include expected_url
    end

    context "help" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "help when" }
      end

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
