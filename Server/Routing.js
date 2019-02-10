const ev = require('express-validation');
function SetupRouting(app) {
    let validate = require('express-validation')
        , bodyParser = require('body-parser')
        , cookieParser = require('cookie-parser');

    app.use(bodyParser.json())
    app.use(cookieParser())


    let StudentExamsController = require('./FE/Controllers/StudentExamsController.js');
    app.use('/exams', StudentExamsController);

    let AdminExamController = require('./FE/Controllers/AdminExamsController.js');
    app.use('/admin/Exams',AdminExamController);






    // error handler, required as of 0.3.0
    app.use(function (err, req, res, next) {
        if (err instanceof ev.ValidationError) return res.status(err.status).json(err);
        // other type of errors, it *might* also be a Runtime Error
        if (process.env.NODE_ENV !== 'production') {
            return res.status(500).send(err.stack);
        } else {
            return res.sendStatus(500);
        }
    });
}
module.exports = SetupRouting;