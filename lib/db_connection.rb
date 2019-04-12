module MakersORM
  class DBConnection
    def initialize(credentials)
        @conn = PG.connect(credentials.to_hash)
        @conn.type_map_for_queries = PG::BasicTypeMapForQueries.new(@conn)
        @conn.type_map_for_results = PG::BasicTypeMapForResults.new(@conn)
      	@conn.exec %q{SET client_min_messages TO WARNING;}
    end

    def method_missing(method, *args, &block)
      conn.send(method, *args, &block)
    end

    def respond_to_missing?(method, include_private = false)
      conn.respond_to?(method)
    end

    private

    attr_reader :conn
  end
end