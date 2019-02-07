//load config file
global.gConfig = require('./config.json');

var express = require('express');
var app = express();

require("./Routing.js")(app);
app.listen(global.gConfig.HttpPort, () => console.log(`strted http server`));