module SlashCommand
  Invoke.setup help: Commands::Help,
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
                Commands::Today,
                Commands::Display
               ]
end
