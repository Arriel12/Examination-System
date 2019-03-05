const Hasher = require("../Helpers/Hasher.js");
const JWT = require("../Helpers/JWT.js");
const LoginStatues = require("../../Common/Enums/LoginStatus.js");
const Mailler = require("../Helpers/Mailer.js");
const ReturnStatus = require("../../Common/Enums/ReturnStatus.js");

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
        if (res.recordsets[0].length > 0 && res.recordsets[0][0].UserId != null &&
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

    async Register(user) {
        let userParms = {
            email: user.username,
            PassHash: await Hasher.Hash(user.password)
        }
        let res;
        try {
            res = await this.Db.ExecuteStoredPorcedure("CreateUser", userParms);
        }
        catch (err) {
            if (err.code != undefined && err.code === "EREQUEST" &&
                err.originalError != undefined && err.originalError.info != undefined
                && err.originalError.info.message.includes("Violation of UNIQUE KEY constraint")) {
                //email exsists
                return ReturnStatus.DuplicateError;
            }
            throw err;
        }
        let encodedId = Hasher.EncodeValue(res.recordsets[0][0].UserId.toString());
        let encodedEmail = Hasher.EncodeValue(user.username);
        let url = global.gConfig.baseUrl + global.gConfig.EmailValidationUrl + "/" +
            encodedId + "/" + encodedEmail;
        let sender = global.gConfig.Mailler.ValidationSender;
        let content = global.gConfig.Mailler.ValidationText.replace(new RegExp('{url}', 'g'), url);
        let subject = global.gConfig.Mailler.ValidationSubject;
        try {
            //TODO: add await (when email isnt blocked by firewall)
            await Mailler.SendEmail(sender, user.username, subject, content);
        } catch (err) {
            return ReturnStatus.EmailError;
        }
        return ReturnStatus.Seccuss;
    }

    async ValidateUser(encodedId, encodedEmail) {
        try {
            var userId = Hasher.DecodeValue(encodedId);
            var email = Hasher.DecodeValue(encodedEmail);
        }
        catch {
            return ReturnStatus.ArgumentsError;
        }
        let res = await this.Db.ExecuteStoredPorcedure("VerifyUser", { UserId: userId, Email: email });
        if (res.recordsets[0][0].AffectedRow > 0)
            return ReturnStatus.Secucces;
        return ReturnStatus.ArgumentsError;
    }

    async RestUserPassword(encodedId, encodedEmail, password) {
        try {
            var userId = Hasher.DecodeValue(encodedId);
            var email = Hasher.DecodeValue(encodedEmail);
        }
        catch {
            return ReturnStatus.ArgumentsError;
        }
        let parms = {
            UserId: userId,
            Email: email,
            PassHash: await Hasher.Hash(password)
        }
        let res = await this.Db.ExecuteStoredPorcedure("ResetUserPassword", parms);
        if (res.recordsets[0][0].AffectedRow > 0)
            return ReturnStatus.Secucces;
        return ReturnStatus.ArgumentsError;
    }

    async SendResetEmail(username) {
        let res = await this.Db.ExecuteStoredPorcedure("GetUser", { email: username });
        if (res.recordsets[0].length == 0)
            return ReturnStatus.ArgumentsError;
        let restUrl = global.gConfig.ClientUrl + global.gConfig.RestPasswordUrl +
            "/" + Hasher.EncodeValue(res.recordsets[0][0].UserId.toString()) + "/" +
            Hasher.EncodeValue(res.recordsets[0][0].Email);
        let sender = global.gConfig.Mailler.PasswordResetSender;
        let content = global.gConfig.Mailler.PasswordResetText.replace(new RegExp('{url}', 'g'), restUrl);
        let subject = global.gConfig.Mailler.PasswordResetSubject;
        Mailler.SendEmail(sender, res.recordsets[0][0].Email, subject, content);
        return ReturnStatus.Seccuss;
    }
}

module.exports = UsersManager;