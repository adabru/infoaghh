#!/usr/bin/env node

const http = require('http')
const fs = require('fs')
const path = require('path')

const contenttypes = require('./contenttypes.json')

help = () => console.log(`

\x1b[1musage\x1b[0m: main.ls iface port

`)

iface = process.argv[2]
port = process.argv[3]
if (!iface || !port)
  return help()

function route(path) {
  switch (true) {
    case path == '/':
      return './main.html'
    case /^\/[\d][\d]W[\d][\d]$/.test(path):
      return `./blog${path}/index.html`
    default:
      return `.${path}`
  }
}

http.createServer( (req, res) => {
  req.url = unescape(req.url)
  switch(true) {
    case req.url != path.normalize(req.url):
      res.writeHead(400)
      res.end('invalid path')
      break
    default:
      filepath = route(req.url)
      fs.createReadStream(filepath)
        .on('error', () => {
          res.writeHead(404)
          res.end('404 not found')
        }).on('open', () => {
          res.writeHead(200, {'content-type': (contenttypes[path.extname(filepath)] || 'text/plain')})
        }).pipe(res)
  }
})
.listen(port, iface, () => console.log(`server running on http://${iface}:${port}`))

