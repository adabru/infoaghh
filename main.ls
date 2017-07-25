#!/usr/bin/env lsc

require! [http,fs]

help = -> console.log '''

\033[1musage\033[0m: main.ls iface port

'''
iface = process.argv.2
port = process.argv.3
if not iface? or not port? then return help!

http.createServer (req, res) ->
  switch req.url
    case '/raspberries'
      res.writeHead 200, 'content-type': 'image/jpg'
      fs.createReadStream('./raspberries.jpg').pipe res
    case '/favicon'
      res.writeHead 200, 'content-type': 'image/png'
      fs.createReadStream('./favicon.png').pipe res
    default
      res.writeHead 200, 'content-type': 'text/html'
      fs.createReadStream('./main.html').pipe res
.listen port, iface, -> console.log "server running on http://#{iface}:#{port}"
