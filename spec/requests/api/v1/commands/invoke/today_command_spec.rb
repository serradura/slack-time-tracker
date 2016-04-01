require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "today" }
  #let(:current_user) { User.last }
  let(:template_command) { SlashCommand::Commands::Template }
  let(:current_command) { SlashCommand::Commands::Today }

  describe "'today' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    it "responds with status 200" do
      expect(response).to have_http_status(200)
      expect(response.body).to_not include template_command.description
    end

    context "when there is an activity in progress" do
      let(:payload_text) { "in foo bar" }
      let(:number_of_headers) { 1 }
      let(:number_of_inputs) { 1 }
      
      before do
        payload.text = "today"
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "return the number of registered activities" do
        expect(response).to have_http_status(200)
        lineNumber = response.body.split("\n").length
        expect(lineNumber).to be == number_of_inputs + number_of_headers
      end

      it "checks if foo bar text appears on response" do
        expect(response).to have_http_status(200)

        # expect(respons).to be == number_of_inputs + number_of_headers
      end
    end

    context "there is no registered activity" do
	    it "responds with the default 'no activity' message" do
	      expect(response).to have_http_status(200)
	      expect(response.body).to be == current_command::NO_HISTORY_ACTIVITY
	    end
		end
  end
end
