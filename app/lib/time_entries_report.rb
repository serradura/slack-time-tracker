class TimeEntriesReport
  attr_reader :relation

  def initialize(relation)
    @relation = relation
  end

  def build
    "#{header}\n#{body}"
  end

  private

  def th(text, type=nil)
    type == :last ? "\t\t#{text}" : "\t\t#{text}\t\t|"
  end

  def header
    th('Date')+th('Start')+th('End')+th('Duration')+th('Note', :last)
  end

  def body
    relation
      .map(&:to_display)
      .join("\n".freeze)
      .tap(&:strip!)
  end
end
