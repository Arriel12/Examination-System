
var express = require('express');
var router = express.Router();
const validate = require('express-validation')

const StudentExamsMsnsger = require("../../BL/Managers/StudentExamsManager.js");
const Volidators = require("../Validation/StudentExams.js");
const asyncWrapper = require("../Middaleware/AsyncWraper.js");

const manager = new StudentExamsMsnsger();

router.post('/:examId', validate(Volidators.newExam),
    asyncWrapper(async function (req, res) {
        let student = req.body;
        let examId = req.params.examId;
        let res =await manager.StartNewExam(examId, student);
        res.status(200).send(res);
    }));

router.post('/:examId/answer', validate(Volidators.answer),
    asyncWrapper(async function (req, res) {
        let examId = req.params.examId;
        let answers = req.body.answers;
        let questionId = req.body.questionId;
        await manager.AnswerQuestion(examId, questionId, answers);
        res.status(200).send();
    }));

router.post('/:examId/submit', asyncWrapper(async function (req, res) {
    let examId = req.params.examId;
    await manager.SubmitTest(examId);
    res.status(200).send();
}));

module.exports = router;