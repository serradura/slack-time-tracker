require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'what' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) { create(:slack_what_command_payload) }

    it "responds with the event lectures" do
      first_lecture_url  = "http://hey.wearestac.com/lectures/a-pint-with-the-pub-landlord"
      second_lecture_url = "http://hey.wearestac.com/lectures/kickstarting-a-city-wide-food-festival"

      expect(response).to have_http_status(200)
      expect(response.body).to include first_lecture_url
      expect(response.body).to include second_lecture_url
    end

    context "help" do
      let(:payload) do
        create(:slack_what_command_payload).tap {|pay| pay.text = "#{pay.text} help"}
      end

      it "responds with command instructions" do
        expected_message = "This command will show you all the event lectures."

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
