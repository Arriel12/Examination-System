const SqlStatus = require("../../Common/Enums/SqlStatus.js");
const OjectHelper = require("../Helpers/ObjectHelpers");

class AdminExamsManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async CreateQuestion(question, organizationId) {
        question.CorrectCount = 0;
        let answersTable = this.Db.GetAnswersTable();
        question.answers.forEach(element => {
            answersTable.rows.add(element.answer, element.isCorrect);
            if (element.isCorrect)
                question.CorrectCount++;
        });
        if (question.CorrectCount == 0 || (!question.isMultipleChoice && question.CorrectCount > 1)) {
            return SqlStatus.ArgumentsError;
        }
        question.answers = answersTable;
        question.organizationId = organizationId;
        question.categories = this.Db.CnvertToIdTable(question.categories);
        let res = await this.Db.ExecuteStoredPorcedure("CreateQuestion", question);
        return res.recordsets[0][0];
    }

    async ListQuestions(organizationId, categoryId) {
        let res = await this.Db.ExecuteStoredPorcedure("ListQuestions", { OrganizationId: organizationId, CategoryId: categoryId });
        return res.recordsets[0];
    }

    async GetQuestion(organizationId, categoryId, questionId) {
        let parms = {
            OrganizationId: organizationId,
            CategoryId: categoryId,
            QuestionId: questionId
        };
        let res = await this.Db.ExecuteStoredPorcedure("GetQuestion", parms);
        if (res.recordsets.length < 2)
            return SqlStatus.ArgumentsError;
        let question = res.recordsets[0][0];
        question.answers = res.recordsets[1];
        return question;
    }

    async UpdateQuestion(organizationId, categoryId, questionId, data) {
        this._fillQuestionUpdateData(data, organizationId, categoryId, questionId);
        let answers = this.Db.GetAnswersUpdateTable();
        data.answers.forEach(element => {
            OjectHelper.addPropertyIfMissing(element, "id", -1);
            answers.rows.add(element.answer, element.isCorrect, element.id);
            if (element.isCorrect)
                data.correctCount++;
        });
        data.answers = answers;
        if (data.correctCount == 0 || (!data.isMultipleChoice && data.correctCount > 1)) {
            return {
                status: SqlStatus.ArgumentsError,
                message: "invalid amount of correct questions"
            }
        }
        let res = await this.Db.ExecuteStoredPorcedure("UpdateQuestion", data);
        if (res.recordsets.length != 0)
            return {
                status: SqlStatus.ArgumentsError,
                message: res.recordsets[0][0].Error
            };
        else
            return {
                status: SqlStatus.Seccuss
            };
    }

    async DeleteQuestion(organizationId, questionId) {
        let res = await this.Db.ExecuteStoredPorcedure("DeleteQuestion", { QuestionId: questionId, OrganizationId: organizationId });
        return res.recordsets[0][0];
    }

    _fillQuestionUpdateData(data, organizationId, categoryId, questionId) {
        OjectHelper.addPropertyIfMissing(data, "isHorizontal", null);
        OjectHelper.addPropertyIfMissing(data, "question", null);
        OjectHelper.addPropertyIfMissing(data, "tags", null);
        OjectHelper.addPropertyIfMissing(data, "textBelowQuestion", null);
        data.organizationId = organizationId;
        data.categoryId = categoryId;
        data.questionId = questionId;
        data.correctCount = 0;
    }
}

module.exports = AdminExamsManager;