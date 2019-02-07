import { shuffle } from "../Helpers/ArrayHelper";
import { FormatEmailBody, SendEmail } from "../Helpers/Mailer";
import { EncodeValue } from "../Helpers/Hasher";

class StudentsExamManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async StartNewExam(examId, student) {
        await this._createStudent(student);
        const exam = await this.Db.ExecuteStoredPorcedure('GetExamStudent', examId);
        let examDto =
        {
            examId: exam[0].Id,
            language: exam[0].Language,
            name: exam[0].Name,
            openingText: exam[0].OpeningText,
            passingGrade: exam[0].PassingGrade,
            questions: []
        };
        let qestions = exam[1];
        let answers = exam[2];
        await this._createStudentExam(qestions, answers, examDto, student);
        return examDto;
    }

    async AnswerQuestion(studentExamId, questionId, answerIds) {
        let answersParms = {
            StudentExamId: studentExamId,
            QuestionId: questionId,
            AnswerIds: this.Db.CnvertToIdTable(answerIds)
        }       
        await this.Db.ExecuteStoredPorcedure('SaveStudentAnswers', answersParms);
    }

    async SubmitTest(studentExamId) {
        let SubmitParms =
        {
            StudentExamId: studentExamId,
            FullData: true
        }
        let results = await this.Db.ExecuteStoredPorcedure('GetGrade');
        results = results[0];
        //genrate cert url
        let certUrl = global.gConfig.baseUrl + global.gConfig.CertGenerationUrl +
            '?Id=' + EncodeValue(studentExamId);

        //send mail
        if (results[0].OrganaizerEmail) {
            let body = FormatEmailBody(results[0].Body, results[0].Name,
                results[0].StudentFirstName, results[0].StudentLastName,
                results[0].ExamDate, results[0].Grade, certUrl);
            SendEmail(results[0].OrganaizerEmail, results[0].StudentEmail,
                results[0].Subject, body);
        }
        //generate and return results dto
        let ResultsDto =
        {
            grade: results.Grade,
            text: results.text,
            passed: results.Passed,
            showAnswers: results.ShowAnswer,
            passingGrade: results.PassingGrade,
            certificate: certUrl
        }
        return ResultsDto;
    }

    async _createStudentExam(qestions, answers, examDto, student) {
        var questionsOrder = this.Db.GetQuestionOrderTable();
        var answersOrder = this.Db.GetAnswersOrderTable();
        let answerIdx = 0;
        answerIdx = this._StructureQuestions(qestions, answerIdx, answers, answersOrder, examDto);
        this._SetQuestionsOrder(examDto, questionsOrder);
        let createStudentExamParms = {
            ExamId: examDto.id,
            StudentEmail: student.email,
            QuestionsOrder: questionsOrder,
            AnswersOrder: answersOrder
        };
        let studenttestId = await this.Db.ExecuteStoredPorcedure('CreateStudentExam', createStudentExamParms);
        studenttestId = studenttestId[0].Id;
        examDto.id = studenttestId;
    }

    _StructureQuestions(qestions, answerIdx, answers, answersOrder, examDto) {
        for (let i = 0; i < qestions.length; i++) {
            let questionId = questions[i].Id;
            let question = {
                id: questionId,
                isHorizontal: questions[i].IsHorizontal,
                isMultipleChoice: questions[i].IsMultipleChoice,
                question: questions[i].Question,
                textBelow: questions[i].TextBelowQuestion,
                answers: []
            };
            answerIdx = this._AddAnswersToQuestion(answerIdx, answers, question);
            this._SetQuestionAnswersOrder(question, answersOrder, questionId);
            examDto.questions.push(question);
        }
        return answerIdx;
    }

    _SetQuestionsOrder(examDto, questionsOrder) {
        examDto.questions = shuffle(examDto.questions);
        for (let j = 0; j < examDto.questions.length; j++) {
            questionsOrder.rows.add(examDto.questions[j].id, j + 1);
        }
    }

    _SetQuestionAnswersOrder(question, answersOrder, questionId) {
        question.answers = shuffle(question.answers);
        for (let j = 0; j < question.answers.length; j++) {
            answersOrder.rows.add(question.answers[j].id,
                questionId, j + 1);
        }
    }

    _AddAnswersToQuestion(answerIdx, answers, question) {
        while (answerIdx < answers.length &&
            answers[answerIdx].QuestionId === question.id) {
            let answer = {
                id: answers[answerIdx].Id,
                answer: answers[answerIdx].Answer
            };
            question.answers.push(answer);
            answerIdx++;
        }
        return answerIdx;
    }

    async _createStudent(student) {
        let studentParms = {
            studentEmail: student.email,
            studentPhone: student.phone,
            studentFirstName: student.firstName,
            studentLastName: student.lastName
        };
        await this.Db.ExecuteStoredPorcedure('CreateStudentIfNotExsists', studentParms);
    }


}
module.exports = StudentsExamManager;