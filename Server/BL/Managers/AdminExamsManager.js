const Hasher = require('../Helpers/Hasher.js')
class AdminExamsManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async ListExams(orgId) {
        let res = await this.Db.ExecuteStoredPorcedure("GetExamsList", { OrganizationId: orgId });
        res = res.recordsets[0];
        res.forEach(element => {
            element.url = global.gConfig.baseUrl + "/exams/" +
                Hasher.EncodeValue(element.Id.toString());
        });
        return res;
    }

    async CreateExam(orgId, data) {
        data['OrganizationId'] = orgId;
        data.questionsIds = this.Db.CnvertToIdTable(data.questionsIds);
        let res = await this.Db.ExecuteStoredPorcedure('CreateExam', data);
        return {
            examId:res.recordsets[0][0].ExamId,
            url:global.gConfig.baseUrl + "/exams/" + Hasher.EncodeValue(element.Id.toString())
        };
    }

    async GetExam(examId) {
        let res = await this.Db.ExecuteStoredPorcedure('GetExamAdmin', { ExamId: examId });
        //spreads the first test(only 1 returned) into the object(creates clone and add questions)
        let exam = {
            ...res.recordsets[0][0],
            questions: res.recordsets[1],
            url:global.gConfig.baseUrl + "/exams/" + Hasher.EncodeValue(examId.toString())
        };
        return exam;
    }

    async UpdateExam(examId, data) {
        data.ExamId = examId;
        data.questionsIds = this.Db.CnvertToIdTable(data.questionsIds);
        await this.Db.ExecuteStoredPorcedure('UpdateExam', data);
    }
}

module.exports = AdminExamsManager;