require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'kill' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "unknown kill command" do
      let(:payload) do
        create(:slack_kill_command_payload).tap {|pay| pay.text = "kill#{[' ', "\n", "\t", " adad"].sample * rand(20)}" }
      end

      it "return a unknown message and a command help" do 
        expected_message = SlashCommand::Commands::Kill::COMMAND_NOT_VALID
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end 
    end

    # context "correct command" do

    #   context "activity in progress" do
    #     let(:payload) do
    #       create(:slack_in_command_payload)
    #     end

    #     before do
    #       payload.text = "kill current"
    #       post api_v1_commands_invoke_path, payload.to_h
    #     end

    #     it "return a success message and delete the last activity" do 
    #       expected_message = SlashCommand::Commands::Kill::ACTIVITY_DELETED
    #       expect(response).to have_http_status(200)
    #       expect(response.body).to be == expected_message
    #     end 
    #   end

    #   context "activity not progress" do
    #     let(:payload) do
    #       create(:slack_kill_command_payload)
    #     end

    #     it "return with a message that activity is not running " do 
    #       expected_message = SlashCommand::Commands::Kill::ACTIVITY_NOT_RUNNING_MSG
    #       expect(response).to have_http_status(200)
    #       expect(response.body).to be == expected_message
    #     end 
    #   end
      
    # end

    context "help" do
      let(:payload) do
        create(:slack_kill_command_payload).tap {|pay| pay.text = "kill help" }
      end

      it "responds with command instructions" do
        expected_message = SlashCommand::Commands::Kill::HELP
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
