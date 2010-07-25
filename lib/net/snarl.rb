require 'socket'

module Net
  class Snarl
    HEADER = "type=SNP".freeze
    PROTOCOL_VERSION = "version=1.0".freeze
    TERMINATOR = "\r\n".freeze
    DEFAULT_TIMEOUT = 10

    attr_reader :host, :port

    def initialize(host = nil, port = nil)
      @host = host || '127.0.0.1'
      @port = (port || 9887).to_i
    end

    def notify(*args)
      params = args.last || {}
      add_defaults(params)

      response = connected { |c| c.write command('notification', params) }
    end

    def register(app)
      response = connected { |c| c.write command('register', :app => app) }
    end

    def unregister(app)
      response = connected { |c| c.write command('unregister', :app => app) }
    end

    def add_class(app, klass, *args)
      params = args.last || {}
      params[:app] = app
      params[:class] = klass

      response = connected { |c| c.write command('add_class', params) }
    end

    private

    def command(action, params)
      cmd = [HEADER, PROTOCOL_VERSION, "action=#{action}"]

      params.each do |k, v|
        cmd << "#{k}=#{v}"
      end

      cmd.join('#?') + TERMINATOR
    end

    def add_defaults(params)
      params[:timeout] ||= DEFAULT_TIMEOUT
      params
    end

    def connected
      TCPSocket.open(@host, @port) do |s|
        yield s
        s.gets
      end
    end
  end
end
