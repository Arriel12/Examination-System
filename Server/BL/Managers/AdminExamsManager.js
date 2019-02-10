class AdminExamsManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    ListExams(orgId) {
        let res = this.Db.ExecuteStoredPorcedure("GetExamsList", { OrganizationId: orgId });
        res = res[0];
        res.forEach(element => {
            element.url = global.gconfig.baseUrl + "/exams/" + element.Id;
        });
        return res;
    }

    CreateExam(orgId, data) {
        data['OrganizationId'] = orgId;
        data.questionsIds = this.Db.CnvertToIdTable(data.questionsIds);
        let res =this.Db.ExecuteStoredPorcedure('CreateExam', data);
        return res[0];
    }

    GetExam(examId)
    {
        let res = this.Db.ExecuteStoredPorcedure('GetExamAdmin',{ExamId: examId});
        //spreads the first test(only 1 returned) into the object(creates clone and add questions)
        let exam ={
            ...res[0][0], 
            questions:res[1]
        };
        return exam;
    }

    UpdateExam(examId,data)
    {
        data.ExamId = examId;
        data.questionsIds = this.Db.CnvertToIdTable(data.questionsIds);
        this.Db.ExecuteStoredPorcedure('UpdateExam',data);
    }
}

module.exports = AdminExamsManager;