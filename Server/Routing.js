const ev = require('express-validation');
function SetupRouting(app) {
    let validate = require('express-validation')
        , bodyParser = require('body-parser')
        , cookieParser = require('cookie-parser');

        //allow cors
    app.use(function (req, res, next) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods","GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
        res.header("Access-Control-Expose-Headers","x-token");
        next();
    });

    app.use(bodyParser.json())
    app.use(cookieParser())


    let StudentExamsController = require('./FE/Controllers/StudentExamsController.js');
    app.use('/exams', StudentExamsController);

    let AdminExamController = require('./FE/Controllers/AdminExamsController.js');
    app.use('/admin/exams', AdminExamController);

    let QuestionsController = require('./FE/Controllers/QuestionsController.js');
    app.use('/admin/questions', QuestionsController);
    
    let CategoriesController = require('./FE/Controllers/CategoriesController.js');
    app.use('/admin/categories',CategoriesController);

    let ReportsController = require('./FE/Controllers/ReportsController.js');
    app.use('/admin/reports',ReportsController);

    let UsersController = require('./FE/Controllers/UsersController.js');
    app.use('/admin',UsersController);



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