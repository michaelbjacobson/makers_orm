require 'date'

module MakersORM
  class Database
    include DBTypes
    using CoreRefinements

    def self.update(table:, attributes: {}, where: {})
      placeholders = (1..attributes.length).map { |i| "$#{i}" }
      data = attributes.keys.each_with_index.map { |column, index| %Q{#{column}=#{placeholders[index]}} }.join(',')

      query = "UPDATE #{table} SET #{data}"
      query << " WHERE #{condition attributes: where, operator: 'AND'}" unless where.empty?
      query << ' RETURNING *;'

      connection.exec_params(query, attributes.values)
    end

    def self.delete_from(table:, where: {})
      query = "DELETE FROM #{table}"
      query << " WHERE #{condition attributes: where, operator: 'AND'}" unless condition.empty?
      query << ';'
      connection.exec query
      true
    end

    def self.create_table(name)
      query = "CREATE TABLE IF NOT EXISTS #{name} (id serial);"
      connection.exec query
      true
    end

    def self.add_column(table, column, type)
      query = "ALTER TABLE #{table} ADD COLUMN IF NOT EXISTS #{column} #{DBTypes::MAP[type]};"
      connection.exec query
      true
    end

    def self.select_from(table:, column: '*', where: {})
      query = "SELECT #{column} FROM #{table}"
      query << " WHERE #{condition attributes: where, operator: 'AND'}" unless where.empty?
      query << ';'
      connection.exec query
    end

    def self.insert_row(table, attributes = {})
      query = "INSERT INTO #{table} "
      query << values(attributes: attributes, placeholders: true)
      query << ' RETURNING *;'
      connection.exec_params(query, attributes.values).first['id']
      true
    end

    def self.values(attributes: {}, placeholders: false)
      return 'DEFAULT VALUES' if attributes.empty?

      columns = attributes.keys.join(', ')
      values = (placeholders ? (1..attributes.length).map { |i| "$#{i}" } : attributes.values).join(', ')
      "(#{columns}) VALUES (#{values})"
    end

    def self.condition(attributes: {}, operator: 'AND')
      attributes.map { |column, value| "#{column}='#{value}'" }.join(" #{operator} ")
    end

    def self.credentials
      @credentials ||= DBCredentials.new(url)
    end

    def self.connection
      @connection ||= DBConnection.new(credentials)
    end

    def self.url
      if ENV['RACK_ENV'] == 'test' && MakersORM.configuration.test_db_url
        return MakersORM.configuration.test_db_url
      end

      MakersORM.configuration.db_url
    end

    private_class_method :credentials, :connection, :url, :condition, :values
  end
end
