const SqlStatus = require("../../Common/Enums/ReturnStatus");
const ObjectHelper = require("../Helpers/ObjectHelpers");

class ReportsManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async GenerateExamReport(data) {
        ObjectHelper.addPropertyIfMissing(data, "startDate", null);
        ObjectHelper.addPropertyIfMissing(data, "endDate", null);
        let res = await this.Db.ExecuteStoredPorcedure("ExamBasedReport", data);
        let median = res.recordsets[1][0].Median;
        if (res.recordsets[1].length == 2) {
            median += res.recordsets[1][1].Median;
            median /= 2;
        }
        else if (res.recordsets[1].length == 3)
            median = res.recordsets[1][1].Median;
        let report = {
            Statitics: {
                ...res.recordsets[0][0],
                Median: median
            },
            StudentsStatistics: res.recordsets[2],
            QuestionStatistics: res.recordsets[3]
        }
        return report;
    }

    async GetStudentAnswers(data) {
        let res = await this.Db.ExecuteStoredPorcedure("GetStudentAnswers", data);
        let questions = res.recordsets[0];
        let answers = res.recordsets[1];
        let i = 0, j = 0;
        while (i < questions.length) {
            questions[i].answers = [];
            let wrong = 0;
            while (j < answers.length && questions[i].Id === answers[j].QuestionId) {
                questions[i].answers.push(answers[j]);
                delete answers[j].QuestionId;
                if((answers[j].IsSelected && !answers[j].IsCorrect)||
                (!answers[j].IsSelected && answers[j].IsCorrect))
                    wrong++;
                j++;
            }
            if(questions[i].answers.length>0 && wrong==0)
                questions[i].IsCorrect = true;
            else
                questions[i].IsCorrect = false;
            i++;
        }
        return questions;
    }

    async GetQuestionExamStatistics(data) {
        ObjectHelper.addPropertyIfMissing(data, "startDate", null);
        ObjectHelper.addPropertyIfMissing(data, "endDate", null);
        let res = await this.Db.ExecuteStoredPorcedure("GetQuestionExamStatistics", data);
        return res.recordsets[0];
    }

    async GenerateSutdentRepot(data) {
        let res = await this.Db.ExecuteStoredPorcedure("StudentBasedRepot", data);
        return res.recordsets[0];
    }

    async ListStudents() {
        let res = await this.Db.ExecuteStoredPorcedure("ListStudents", {});
        return res.recordsets[0];
    }
}

module.exports = ReportsManager;