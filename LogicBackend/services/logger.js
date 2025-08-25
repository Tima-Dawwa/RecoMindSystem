var express = require('express')
var fs = require('fs')
var morgan = require('morgan')
var path = require('path')

var logger = express()

var accessLogStream = fs.createWriteStream(path.join(__dirname, '../', 'access.log'), { flags: 'a' })

logger.use(morgan(':remote-addr - :remote-user [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length] ":referrer" ":user-agent" :response-time ms', { stream: accessLogStream }))

module.exports = logger;