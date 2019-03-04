const shuffle = require("../Helpers/ArrayHelpers").shuffle;
const Mailer = require("../Helpers/Mailer");
const Hasher = require("../Helpers/Hasher");

class StudentsExamManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async StartNewExam(encodedExamId, student) {
        await this._createStudent(student);
        let examId = Hasher.DecodeValue(encodedExamId);
        const exam = await this.Db.ExecuteStoredPorcedure('GetExamStudent', { examId: examId });
        let examDto =
        {
            examId: exam.recordsets[0][0].Id,
            language: exam.recordsets[0][0].Language,
            name: exam.recordsets[0][0].Name,
            openingText: exam.recordsets[0][0].OpeningText,
            passingGrade: exam.recordsets[0][0].PassingGrade,
            questions: []
        };
        let qestions = exam.recordsets[1];
        let answers = exam.recordsets[2];
        await this._createStudentExam(qestions, answers, examDto, student);
        examDto.examId = Hasher.EncodeValue(examDto.examId.toString());
        examDto.id = Hasher.EncodeValue(examDto.id.toString());
        return examDto;
    }

    async AnswerQuestion(studentExamId, questionId, answerIds) {
        studentExamId = Hasher.DecodeValue(studentExamId);
        let answersParms = {
            StudentExamId: studentExamId,
            QuestionId: questionId,
            AnswerIds: this.Db.CnvertToIdTable(answerIds)
        }
        return await this.Db.ExecuteStoredPorcedure('SaveStudentAnswers', answersParms);
    }

    async SubmitTest(studentExamId) {
        studentExamId = Hasher.DecodeValue(studentExamId);
        let SubmitParms =
        {
            StudentExamId: studentExamId,
            FullData: true
        }
        let results = await this.Db.ExecuteStoredPorcedure('GetGrade', SubmitParms);
        results = results.recordsets[0][0];
        if (results.Error) {
            return {
                error: results.Error
            };
        }
        //genrate cert url
        let certUrl = null;
        if (results.CertificateUrl) {
            certUrl = global.gConfig.baseUrl + global.gConfig.CertGenerationUrl +
                '/' + Hasher.EncodeValue(studentExamId);
        }
        //send mail
        if (results.OrganaizerEmail) {
            let body = Mailer.FormatEmailBody(results.Body, results.Name,
                results.StudentFirstName, results.StudentLastName,
                results.ExamDate, results.Grade, certUrl);
            Mailer.SendEmail(results.OrganaizerEmail, results.StudentEmail,
                results.Subject, body);
        }
        //generate and return results dto
        let ResultsDto =
        {
            grade: results.Grade,
            text: results.Text,
            passed: results.Passed,
            showAnswers: results.ShowAnswer,
            passingGrade: results.PassingGrade,
            certificate: certUrl
        }
        return ResultsDto;
    }

    async GetAnswers(studentExamId) {
        studentExamId = Hasher.DecodeValue(studentExamId);
        let data ={studentExamId:studentExamId};
        let res = await this.Db.ExecuteStoredPorcedure("ShowAnswersToStudent", data);
        if (res.recordsets[0][0].Error)
            return { error: res.recordsets[0][0].Error };
        let questions = res.recordsets[0];
        let answers = res.recordsets[1];
        let i = 0, j = 0;
        while (i < questions.length) {
            questions[i].answers = [];
            let wrong = 0;
            while (j < answers.length && questions[i].Id === answers[j].QuestionId) {
                questions[i].answers.push(answers[j]);
                delete answers[j].QuestionId;
                if ((answers[j].IsSelected && !answers[j].IsCorrect) ||
                    (!answers[j].IsSelected && answers[j].IsCorrect))
                    wrong++;
                j++;
            }
            if (questions[i].answers.length > 0 && wrong == 0)
                questions[i].IsCorrect = true;
            else
                questions[i].IsCorrect = false;
            i++;
        }
        return questions;
    }

    async _createStudentExam(qestions, answers, examDto, student) {
        var questionsOrder = this.Db.GetQuestionOrderTable();
        var answersOrder = this.Db.GetAnswersOrderTable();
        let answerIdx = 0;
        answerIdx = this._StructureQuestions(qestions, answerIdx, answers, answersOrder, examDto);
        this._SetQuestionsOrder(examDto, questionsOrder);
        let createStudentExamParms = {
            ExamId: examDto.examId,
            StudentEmail: student.email,
            QuestionsOrder: questionsOrder,
            AnswersOrder: answersOrder
        };
        let studenttestId = await this.Db.ExecuteStoredPorcedure('CreateStudentExam', createStudentExamParms);
        studenttestId = studenttestId.recordsets[0][0].Id;
        examDto.id = studenttestId;
    }

    _StructureQuestions(questions, answerIdx, answers, answersOrder, examDto) {
        for (let i = 0; i < questions.length; i++) {
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