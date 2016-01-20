module SlashCommand
  Invoke.setup help: Commands::Help,
               default: Commands::Default,
               unknown: Commands::Unknown,
               example: [
                 Commands::When,
                 Commands::What
               ],
               available: [
                 Commands::In,
                 Commands::Out,
                 Commands::Now,
                 Commands::Edit,
                 Commands::Kill,
                 Commands::Display,
                 Commands::Today,
                 Commands::Yesterday
               ]
end
