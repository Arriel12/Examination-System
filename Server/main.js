//load config file
global.gConfig = require('./config.json');

var express = require('express');
var app = express();

require("./Routing.js")(app);
app.listen(global.gConfig.HttpPort, () => console.log(`started http server`));


//import {Hash,Verify} from "./BL/Helpers/Hasher.js";
async function a ()
{
let Hash = require("./BL/Helpers/Hasher.js").Hash;
let a = await Hash('admin');
console.log(a);
};
a();