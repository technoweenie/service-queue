require 'zmq'

context = ZMQ::Context.new
req = context.socket ZMQ::REQ

id = ARGV.shift || :single

req.setsockopt ZMQ::IDENTITY, "requester-#{id}"
req.connect 'tcp://127.0.0.1:5556'

begin
  loop do
    print ">> "
    puts msg = gets.strip

    req.send msg
    puts "=> #{req.recv}"
  end
rescue SignalException
  puts 'closing...'
  req.close
end
