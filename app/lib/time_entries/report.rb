module TimeEntries
  class Report
    attr_reader :relation

    def initialize(relation, data)
      @relation = relation
      @data = data
    end

    def build
      "#{header}\n#{body}"
    end

    def header
      Header.new(@data).build
    end

    def body
      Body.map(relation, @data)
    end
  end
end
