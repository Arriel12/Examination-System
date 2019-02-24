const express = require('express');
const router = express.Router();
const validate = require('express-validation');

const authentication = require('../Middaleware/Autentication.js');
const asyncWrapper = require("../Middaleware/AsyncWraper");

const Validators = require("../Validation/Reports.js");
const ReportsManager = require("../../BL/Managers/ReportsManager.js");

const manager = new ReportsManager();


router.use(authentication);

router.post('/Exam', validate(Validators.Exam),
    asyncWrapper(async function (req, res) {
        let results = await manager.GenerateExamReport(req.body);
        res.status(200).send(results);
    }));

router.post('/Student', validate(Validators.Student),
    asyncWrapper(async function (req, res) {
        let results = await manager.GenerateSutdentRepot(req.body);
        res.status(200).send(results);
    }));

router.post('/QuestionStatistics', validate(Validators.QuestionStatistics),
    asyncWrapper(async function (req, res) {
        let results = await manager.GetQuestionExamStatistics(req.body);
        res.status(200).send(results);
    }));

router.post('/StudentAnswers', validate(Validators.StudentAnswers),
    asyncWrapper(async function (req, res) {
        let results = await manager.GetStudentAnswers(req.body);
        res.status(200).send(results);
    }));


router.get('/Student',
    asyncWrapper(async function (req, res) {
        let results = await manager.ListStudents(req.body);
        res.status(200).send(results);
    }));

module.exports = router;