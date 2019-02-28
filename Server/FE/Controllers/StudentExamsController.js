
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
        let result =await manager.StartNewExam(examId, student);
        res.status(200).send(result);
    }));

router.post('/:studentExamId/answer', validate(Volidators.answer),
    asyncWrapper(async function (req, res) {
        let studentExamId = req.params.studentExamId;
        let answers = req.body.answers;
        let questionId = req.body.questionId;
        let result =await manager.AnswerQuestion(studentExamId, questionId, answers);
        if(result!=null &&result.recordsets[0]!=null &&  result.recordsets[0][0].Error!=undefined)
        {
            res.status(400).send(result.recordsets[0][0].Error);
        }
        else
        {
            res.sendStatus(200);
        }
    }));

router.post('/:studentExamId/submit', asyncWrapper(async function (req, res) {
    let studentExamId = req.params.studentExamId;
    let result =await manager.SubmitTest(studentExamId);
    if(result.error)
        res.status(400).send(result);
    else
        res.status(200).send(result);
}));

module.exports = router;