module MakersORM
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :db_url, :test_db_url

    def initialize
      @db_url = nil
      @test_db_url = nil
    end
  end
end
