

//send email without auth - blocked by sela firewall....

// function SendEmail(from, to, subject, body) {
//     const sendmail = require('sendmail')({ silent: false });
//     sendmail({
//         from: from,
//         to: to,
//         subject: subject,
//         html: body,
//     }, function (err, reply) {
//         console.log(err && err.stack);
//         console.dir(reply);
//     });
//    reqs node mailer vertion 0.71
//     //  const mail = require("nodemailer").mail;
//     // let res =mail({
//     //     from: from, // sender address
//     //     to: to, // list of receivers
//     //     subject: subject, // Subject line
//     //     html: body // html body
//     // });
// }


//send with auth cus of firewall (still blocked)
async function SendEmail(from, to, subject, body) {
    let nodemailer = require('nodemailer');
    let config = global.gConfig.Mailler;
    let transport = nodemailer.createTransport({
        service: config.Provider,
        auth: {
            user: config.User,
            pass: config.Password
        }
    });
    var message = {
        from: from,
        to: to,
        subject: subject,
        html: body
    };
    return new Promise(function (resolve, reject) {
        try {
            transport.sendMail(message, function (error, info) {
                if (error) {
                    reject(error);
                }
                else {
                    transport.close();
                    resolve(info);
                }
            });
        }
        catch (err) {
            reject(error);
        }
    });

}

function FormatEmailBody(body, testName, firstName, lastName, date, grade, certificate) {
    return body.replace(new RegExp('@TestName@', 'g'), testName)
        .replace(new RegExp('@FirstName@', 'g'), firstName)
        .replace(new RegExp('@LastName@', 'g'), lastName)
        .replace(new RegExp('@Date@', 'g'), date)
        .replace(new RegExp('@Grade@', 'g'), grade)
        .replace(new RegExp('@Certificate@', 'g'), certificate);
}

module.exports = { SendEmail, FormatEmailBody };