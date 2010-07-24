require 'net/snarl'

describe Net::Snarl do
  context 'when first created' do
    it 'defaults connection to local server' do
      snarl = Net::Snarl.new
      snarl.host.should == '127.0.0.1'
      snarl.port.should == 9887
    end

    it 'allows connection to remote server' do
      snarl = Net::Snarl.new('remote', 1234)
      snarl.host.should == 'remote'
      snarl.port.should == 1234
    end
  end
end
