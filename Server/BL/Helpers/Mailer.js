

function SendEmail(from,to,subject,body)
{
    const sendmail = require('sendmail')({silent: true});
    sendmail({
        from: from,
        to: to,
        subject: subject,
        html: body,
    }, function(err, reply) {
        console.log(err && err.stack);
        console.dir(reply);
    });
}

function FormatEmailBody(body,testName,firstName,lastName,date,grade,certificate)
{
    return body.replace(new RegExp('@TestName@', 'g'), testName)
               .replace(new RegExp('@FirstName@', 'g'), firstName)
               .replace(new RegExp('@LastName@', 'g'), lastName)
               .replace(new RegExp('@Date@', 'g'), date)
               .replace(new RegExp('@Grade@', 'g'), grade)
               .replace(new RegExp('@Certificate@', 'g'), certificate);
}

module.exports ={SendEmail,FormatEmailBody};