require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:current_command) { SlashCommand::Commands::Help }
  let(:template_command) { SlashCommand::Commands::Template }

  describe "'help' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) do
      create(:slack_payload).tap {|pay| pay.text = "help" }
    end

    it "responds with all commands help descriptions" do
      expect(response).to have_http_status(200)

      expect(response.body).to_not include template_command.description
      expect(response.body).to be == current_command.help
    end

    context "help" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "help help" }
      end

      # TODO: DRY with shared examples.
      it "responds with command instructions" do
        expect(response).to have_http_status(200)

        expect(response.body).to_not include template_command.description
        expect(response.body).to be == current_command.help
      end
    end

    context "unknown help" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "help #{Faker::Lorem.word}" }
      end

      it "responds with unknown command message" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == SlashCommand::Commands::Unknown.help
      end
    end
  end
end
