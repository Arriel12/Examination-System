class MssqlConnection {
    constructor() {
        this.sql = require('mssql')
        this.config = global.gConfig.SqlConfig;
        this.pool = new this.sql.ConnectionPool(this.config).connect(err => {
            if (err)
                console.log('Database Connection Failed! Bad Config: ', err)
            else
                console.log('connected to db');
        });       
    }

    async ExecuteStoredPorcedure(name, params) {
        //await this.pool;
        const req = this.pool.request();
        for (var key in params) {
            if (params.hasOwnProperty(key)) {
                req.input(key, params[key]);
            }
        }
            return await req.execute(name)
    }

    CnvertToIdTable(list) {
        const table = new this.sql.Table();
        table.columns.add("ID", this.sql.Int);
        for (let i = 0; i < list.length; i++) {
            table.rows.add(list[i]);
        }
        return table;
    }

    GetQuestionOrderTable() {
        const table = new this.sql.Table();
        table.columns.add("QuestionId", this.sql.Int);
        table.columns.add("Index", this.sql.TinyInt);
        return table;
    }

    GetAnswersOrderTable() {
        const table = new this.sql.Table();
        table.columns.add("AnswerId", this.sql.Int);
        table.columns.add("QuestionId", this.sql.Int);
        table.columns.add("Index", this.sql.TinyInt);
        return table;
    }

    GetAnswersTable() {
        const table = new this.sql.Table();
        table.columns.add("Answer", this.sql.NVarChar(1000));
        table.columns.add("IsCorrect", this.sql.Bit);
        return table;
    }

    GetAnswersUpdateTable()
    {
        const table = new this.sql.Table();
        table.columns.add("Answer", this.sql.NVarChar(1000));
        table.columns.add("IsCorrect", this.sql.Bit);
        table.columns.add("Id", this.sql.Int);
        return table;
    }
}
const Db = new MssqlConnection();

module.exports = Db;