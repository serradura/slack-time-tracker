# USAGE EXAMPLES:
#
# With arguments:
# rake slack_command_simulator[what,YOUrSLackToKEN,https://your-api-server.herokuapp.com/]
#
# With environment variables:
# SLACK_CMD_TOKEN=YOUrSLackToKEN SLACK_CMD_API_URL=https://your-api-server.herokuapp.com/ rake slack_command_simulator[what]
#
# Mixed strategy:
# SLACK_CMD_API_URL=https://your-api-server.herokuapp.com/ rake slack_command_simulator[what,YOUrSLackToKEN]
desc "Slack command simulator"
task :slack_command_simulator, %i[text token api_url] => [:environment] do |_, args|
  require "mkmf"

  # Runtime dependencies validation
  fail "Error: http tool is required! (Installation instructions: https://github.com/jkbrzt/httpie#installation)" unless find_executable("http")
  fail "Error: Only works in a development environment!" unless Rails.env.development?
  unless File.exist? Rails.root.join("spec/factories/slack_payload_simulator.rb")
    fail <<-ERROR.strip_heredoc
            Create and config your spec/factories/slack_payload_simulator.rb. e.g:\n
            cp spec/factories/sample.slack_payload_simulator spec/factories/slack_payload_simulator.rb
          ERROR
  end

  # Argument validation
  fail "Error: text argument is required!" if String(args.text).tap(&:strip!).blank?

  # Set default arguments
  args.with_defaults api_url: ENV.fetch("SLACK_CMD_API_URL", "http://localhost:3000")

  # Create payload folder if it's doesn't exists
  payload_folder = Rails.root.join("tmp/slack_command_simulator")

  FileUtils.mkdir(payload_folder) unless File.exist?(payload_folder)

  # Generate payload data
  payload = FactoryGirl.create(:slack_payload_simulator)
  payload.text = args.text
  payload.token = ENV.fetch("SLACK_CMD_TOKEN", args.token) || payload.token

  # Generate payload file
  timestamp = Time.now.strftime("%Y%m%d%H%M%S%L")
  command   = args.text.split.first
  payload_file = payload_folder.join("#{command}-#{timestamp}.json")

  # Create json payload file
  File.open(payload_file, "w") {|f| f.puts(payload.to_h.to_json) }

  # Makes a request using httpie.org/
  system("http --timeout=600 POST #{args.api_url} < #{payload_file}")
end
