class AdminExamsManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async CreateQuestion(question,organizationId)
    {
        question.CorrectCount=0;
        let answersTable = this.Db.GetAnswersTable();
        question.answers.forEach(element => {
            answersTable.rows.add(element.answer,element.isCorrect);
            if(element.isCorrect)
            {
                question.CorrectCount++;
            }
        });
        question.answers = answersTable;
        question.organizationId = organizationId;
        question.categories = this.Db.CnvertToIdTable(question.categories);
        return await this.Db.ExecuteStoredPorcedure("CreateQuestion",question);
    }

    async ListQuestions(organizationId,categoryId)
    {
        return await this.Db.ExecuteStoredPorcedure("ListQuestions",{OrganizationId:orientation,CategoryId:categoryId});
    } 
}

module.exports = AdminExamsManager;