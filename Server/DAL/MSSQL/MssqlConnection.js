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

    ExecuteStoredPorcedure(name, params) {
        const req = new this.pool.request();
        for (var key in params) {
            if (p.hasOwnProperty(key)) {
                req.input(key, p[key]);
            }
        }
        return req.execute(name)
    }

    CnvertToIdTable(list) {
        const table = new  this.sql.Table();
        table.columns.add("ID", this.sql.int);
        for (let i = 0; i < list.length; i++) {
            table.rows.add(list[i]);
        }
    }

    GetQuestionOrderTable() {
        const table = new  this.sql.Table();
        table.columns.add("QuestionId", this.sql.int);
        table.columns.add("Index", this.sql.TinyInt);
        return table;
    }

    GetAnswersOrderTable() {
        const table = new  this.sql.Table();
        table.columns.add("AnswerId", this.sql.int);
        table.columns.add("QuestionId", this.sql.int);
        table.columns.add("Index", this.sql.TinyInt);
        return table;
    }
}
const Db = new MssqlConnection();

module.exports = Db;