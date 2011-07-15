require 'zmq'

context = ZMQ::Context.new
req  = context.socket ZMQ::REQ

id = ARGV.shift || :single

req.setsockopt ZMQ::IDENTITY, "worker-#{id}"
req.connect 'tcp://127.0.0.1:5555'

req.send 'ok'

begin
  while requester = req.recv
    msg = req.recv

    req.send requester, ZMQ::SNDMORE
    req.send "#{msg}!"
    puts "Processed #{msg.inspect} for #{requester}"
  end
rescue SignalException
  puts 'closing...'
  req.close
end
