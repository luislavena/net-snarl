require 'socket'

module Net
  class Snarl
    HEADER = "type=SNP".freeze
    PROTOCOL_VERSION = "version=1.0".freeze
    TERMINATOR = "\r\n".freeze

    attr_reader :host, :port

    def initialize(host = nil, port = nil)
      @host = host || '127.0.0.1'
      @port = (port || 9887).to_i
    end

    def notify(*args)
      options = args.last || {}
      options[:action] = 'notification'

      TCPSocket.open(@host, @port) do |s|
        s.write build_command(options)
      end
    end

    private

    def build_command(params)
      cmd = []
      params.each do |k, v|
        cmd << "#{k}=#{v}"
      end
      output = "type=SNP#?version=1.0"
      output << "#?#{cmd.join('#?')}" unless cmd.empty?
      output
    end
  end
end
