const Hasher = require("../Helpers/Hasher.js");
const JWT = require("../Helpers/JWT.js");
const LoginStatues = require("../../Common/Enums/LoginStatus.js");

class UsersManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }


    async Login(username, password) {
        let res = await this.Db.ExecuteStoredPorcedure("GetUser", { email: username });
        let user = {
            email: res.recordsets[0][0].Email,
            organizations: res.recordsets[1]
        };
        let response =
        {
            jwt: null,
            status: LoginStatues.WorngUserNameOrPassword
        }
        if (res.recordsets[0].length > 0 &&
            await Hasher.Verify(password, res.recordsets[0][0].PasswordHash)) {
            if (res.recordsets[0][0].Verified) {
                response.jwt = JWT.create(res.recordsets[0][0].UserId, user);
                response.status = LoginStatues.Secucces;
            }
            else
                response.status = LoginStatues.UnVerified;
        }
        return response;
    }
}

module.exports = UsersManager;