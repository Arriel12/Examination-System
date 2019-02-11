//load config file
global.gConfig = require('./config.json');

process.on('unhandledRejection', (reason, promise) => {
    console.log('Unhandled Rejection at:', reason.stack || reason)
    // Recommended: send the information to sentry.io
    // or whatever crash reporting service you use
  })

var express = require('express');
var app = express();

require("./Routing.js")(app);
app.listen(global.gConfig.HttpPort, () => console.log(`started http server`));


//prints password hash
async function hashPass(pass) {
    let Hash = require("./BL/Helpers/Hasher.js").Hash;
    let a = await Hash(pass);
    console.log(a);
};
//hashPass('admin');

console.log('token: '+require('./BL/Helpers/JWT.js').create(1, { organizations: [1] }));

function delayedHttp(path, method,postData = {},delay =3000)
{
    setTimeout(()=>{selfHttpCall(path, method,postData)},3000);
}


function selfHttpCall(path, method,postData = {}) {
    postData = JSON.stringify(postData);
    const http = require('http');
    let options =
    {
        port: global.gConfig.HttpPort,
        method: method,
        //protocol :'http:',
        headers: {
            'Authorization':'bearer '+ require('./BL/Helpers/JWT.js').create(1, { organizations: [1] })
        },
        path: path
    }
    console.log(options.headers);
    let req =http.request(options, (res) => {
        debugger;
        console.log(`STATUS: ${res.statusCode}`);
        console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
        res.setEncoding('utf8');
        res.on('data', (chunk) => {
            console.log(`BODY: ${chunk}`);
        });
        res.on('end', () => {
            console.log('No more data in response.');
        });
    });
    req.on('error', (e) => {
        console.error(`problem with request: ${e.message}`);
      });
      
      // write data to request body
      req.write(postData);
      req.end();
}

//prints exams list json
function listExams() {
    delayedHttp('/admin/exams/1','GET');
}

//listExams();