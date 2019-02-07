import { StudentExamsMsnsger } from "../../BL/Managers/StudentExamsMsnsger.js";
import { newExam,answer } from "../Validation/StudentExams.js";

var express = require('express')
var router = express.Router()

const manager = new StudentExamsMsnsger();

router.post('/:examId', validate(newExam), function (req, res) {
    let student = req.body;
    let examId = req.params.examId;
    try {
        let res = manager.StartNewExam(examId, student);
        res.status(200).send(res);
    }
    catch
    {
        res.status(500);
    }
});

router.post('/:examId/answer',validate(answer), async function (req, res) {
    let examId = req.params.examId;
    let answers = req.body.answers;
    let questionId = req.body.questionId;
    try {
        await manager.AnswerQuestion(examId, questionId, answers);
        res.status(200).send();
    }
    catch
    {
        res.status(500);
    }
});

router.post('/:examId/submit', async function (req, res) {
    let examId = req.params.examId;
    try {
        await manager.SubmitTest(examId);
        res.status(200).send();
    }
    catch
    {
        res.status(500);
    }
});

module.exports = router;