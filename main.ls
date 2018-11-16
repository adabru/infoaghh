#!/usr/bin/env lsc

require! [http,fs,path]

help = -> console.log '''

\033[1musage\033[0m: main.ls iface port

'''
iface = process.argv.2
port = process.argv.3
if not iface? or not port? then return help!

route = (path) ->
  switch
    case path is '/'
      './main.html'
    case path is /^\/[\d][\d]W[\d][\d]$/
      "./blog#{path}/index.html"
    default
      ".#{path}"

http.createServer (req, res) ->
  req.url = unescape(req.url)
  switch req.url
    case req.url != path.normalize req.url
      res.writeHead 400
      res.end 'invalid path'
    default
      filepath = route req.url
      console.log filepath
      fs.createReadStream(filepath)
        .on 'error', ->
          res.writeHead 404
          res.end '404 not found'
        .on 'open', ->
          contenttypes = {'.js':'application/javascript', '.css':'text/css', '.png':'image/png', '.jpg':'image/jpg', '.html':'text/html'}
          res.writeHead 200, 'content-type': (contenttypes[path.extname filepath] or 'text/plain')
        .pipe res

.listen port, iface, -> console.log "server running on http://#{iface}:#{port}"
