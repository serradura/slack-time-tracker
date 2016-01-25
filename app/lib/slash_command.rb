module SlashCommand
  Invoke.setup help: Commands::Help,
               default: Commands::Default,
               unknown: Commands::Unknown,
               available: [
                 Commands::In,
                 Commands::Out,
                 Commands::Now,
                 Commands::Edit,
                 Commands::Kill,
                 Commands::Resume,
                 Commands::Display,
                 Commands::Today,
                 Commands::Yesterday
               ]
end
