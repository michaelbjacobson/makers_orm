module MakersORM
  class DBCredentials

    def initialize(url, sslmode: 'disable')
      @url = strip_protocol_prefix(url)
      @sslmode = sslmode
    end

    def to_hash
      {
        host: host,
        port: port,
        dbname: dbname,
        user: user,
        password: password,
        sslmode: @sslmode
      }.reject { |_key, value| value.nil? }
    end

    private

    def user_and_password
      return unless url_includes_user?

      @url.split('@').first.split(':')
    end

    def user
      return if user_and_password.nil?

      user_and_password.first
    end

    def password
      return if user_and_password.nil?
      return unless user_and_password.length == 2

      user_and_password.last
    end

    def dbname
      @url.split('/').last
    end

    def host_and_port
      url = @url.include?('@') ? @url.split('@').last : @url
      url.split('/').first.split(':')
    end

    def host
      host_and_port.first
    end

    def port
      host_and_port.last
    end

    def url_includes_user?
      @url.include? '@'
    end

    def strip_protocol_prefix(url)
      %r{:\/\/} =~ url ? url.split('://').last : url
    end
  end
end
