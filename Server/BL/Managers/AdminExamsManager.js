const Hasher = require('../Helpers/Hasher.js')
const addPropertyIfMissing = require('../Helpers/ObjectHelpers.js').addPropertyIfMissing;
class AdminExamsManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async ListExams(orgId,catId) {
        let parms ={ 
            OrganizationId: orgId,
            CategoryId: catId
         };
        let res = await this.Db.ExecuteStoredPorcedure("GetExamsList", parms);
        res = res.recordsets[0];
        res.forEach(element => {
            element.url = global.gConfig.baseUrl + "/exams/" +
                Hasher.EncodeValue(element.Id.toString());
        });
        return res;
    }

    async CreateExam(orgId,catId, data) {
        data['OrganizationId'] = orgId;
        data['CategoryId'] = catId;
        addPropertyIfMissing(data,'orgenaizerEmail',null);
        addPropertyIfMissing(data,'certificateUrl',null);
        addPropertyIfMissing(data,'successMailSubject',null);
        addPropertyIfMissing(data,'successMailBody',null);
        addPropertyIfMissing(data,'failMailSubject',null);
        addPropertyIfMissing(data,'failMailBody',null);
        
        data.questionsIds = this.Db.CnvertToIdTable(data.questionsIds);
        let res = await this.Db.ExecuteStoredPorcedure('CreateExam', data);
        return {
            examId:res.recordsets[0][0].ExamId,
            url:global.gConfig.baseUrl + "/exams/" + Hasher.EncodeValue(res.recordsets[0][0].ExamId.toString())
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
        addPropertyIfMissing(data,'language',null);
        addPropertyIfMissing(data,'name',null);
        addPropertyIfMissing(data,'openningText',null);
        addPropertyIfMissing(data,'orgenaizerEmail',null);
        addPropertyIfMissing(data,'passingGrade',null);
        addPropertyIfMissing(data,'showAnswer',null);
        addPropertyIfMissing(data,'certificateUrl',null);
        addPropertyIfMissing(data,'successText',null);
        addPropertyIfMissing(data,'failText',null);
        addPropertyIfMissing(data,'successMailSubject',null);
        addPropertyIfMissing(data,'successMailBody',null);     
        addPropertyIfMissing(data,'failMailSubject',null);
        addPropertyIfMissing(data,'failMailBody',null);
        data.questionsIds = this.Db.CnvertToIdTable(data.questionsIds);
        return await this.Db.ExecuteStoredPorcedure('UpdateExam', data);
    }

    async DeleteExam(examId,organizationId,categoryId)
    {
        let parms = {
            examId: examId,
            organizationId:organizationId,
            categoryId:categoryId
        }
        return await this.Db.ExecuteStoredPorcedure('DeleteExam',parms);
    }
}

module.exports = AdminExamsManager;