# Binds a Frontend ROUTER socket to 5556.
# Binds a Backend ROUTER socket to 5555.
zmq = require 'zeromq'
closing = false

# The frontend receives REQ messages from Resque workers requesting a service
# hook is called.
frontend   = zmq.createSocket 'router'
requesters = []
frontend.on 'message', (id, b, msg) ->
  console.log "FRONTEND", id.toString(), msg.toString()
  requesters.push [id, msg]
  run()

# The backend receives REQ messages from service workers ready to fulfill a
# Hook.
backend = zmq.createSocket 'router'
workers = [] # List of available service workers
backend.on 'message', (env, b, requester, msg) ->
  console.log "BACKEND", env.toString(), (msg or requester).toString()
  workers.push env
  if !msg?
    msg       = requester
    requester = null
  if requester?
    frontend.send requester, b, msg
  run()

# This is called after every message.  Try to match up a Resque hook task with
# a service hook worker.
run = ->
  if requesters.length == 0
    backend.close() if closing
    return
  return if workers.length == 0

  requester = requesters.shift()
  worker    = workers.shift()

  console.log requester[0].toString(),
    worker.toString(), requester[1].toString()
  backend.send worker, '', requester[0], requester[1]
  run()

frontend.identity = 'broker-frontend'
backend.identity  = 'broker-backend'

frontend.bind 'tcp://127.0.0.1:5556', ->
  console.log 'frontend bound'
backend.bind 'tcp://127.0.0.1:5555', ->
  console.log 'backend bound'

process.on 'SIGQUIT', ->
  console.log "killing gracefully"
  frontend.close()
  closing = true
  run()
