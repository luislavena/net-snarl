module Net
  class Snarl
    attr_reader :host, :port

    def initialize(host = nil, port = nil)
      @host = host || '127.0.0.1'
      @port = (port || 9887).to_i
    end
  end
end
