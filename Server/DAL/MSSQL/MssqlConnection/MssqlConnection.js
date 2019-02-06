class MssqlConnection {
    constructor() {
        this.sql = require('mssql')
        this.config =
            {
                user: 'ExamSql',
                password: '12345678',
                server: 'exam-db.ceuwciuggcni.eu-central-1.rds.amazonaws.com',
                database: 'examsDb',
                pool: {
                    max: 10,
                    min: 0,
                    idleTimeoutMillis: 30000
                }
            }


        this.pool = new this.sql.ConnectionPool(this.config).connect();
        this.pool.on('error', err => {
            console.log('Database Connection Failed! Bad Config: ', err)
        })
    }

    ExecuteStoredPorcedure(name, paramsllbeck) {
        const req = new this.pool.request();
        for (var key in params) {
            if (p.hasOwnProperty(key)) {
                req.input(key, p[key]);
            }
        }
        return req.execute(name)
    }
}
module.exports = MssqlConnection;