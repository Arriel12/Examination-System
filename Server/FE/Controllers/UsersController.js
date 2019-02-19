const express = require('express');
const router = express.Router();
const validate = require('express-validation')

const authentication = require('../Middaleware/Autentication.js');
const asyncWrapper = require("../Middaleware/AsyncWraper");

const LoginStatues = require("../../Common/Enums/LoginStatus.js");
const SqlStatus = require("../../Common/Enums/SqlStatus.js");
const Validators = require("../Validation/UserValidation.js");
const UsersManager = require("../../BL/Managers/UsersManager");
const manager = new UsersManager();


router.post("/login", validate(Validators.Login), asyncWrapper(async function (req, res) {
    let loginRes = await manager.Login(req.body.username, req.body.password);
    switch (loginRes.status) {
        case LoginStatues.Secucces:
            return res.set("x-token", loginRes.jwt).sendStatus(200);
        case LoginStatues.WorngUserNameOrPassword:
            return res.status(401).send("invalid username or password");
        case LoginStatues.UnVerified:
            return res.status(400).send("user hasn't been validated");
    }
}));
router.get("/validate/:id/:email", asyncWrapper(async function (req, res) {
    let encodedId = req.params.id;
    let encodedEmail = req.params.email;
    switch (await manager.ValidateUser(encodedId,encodedEmail))
    {
        case SqlStatus.Secucces:
            return res.status(200).send("validated seccsusfuly");
        case SqlStatus.ArgumentsError:
            return res.status(404).send("invalid url");
    }
}));

router.post("/register",validate(Validators.Register),asyncWrapper(async function (req,res)
{
    let status = await manager.Register(req.body);
    if(status == SqlStatus.Seccuss)
        res.sendStatus(200);
    else if (status == SqlStatus.DuplicateError)
        res.status(400).send("user already exsists");
}));

router.post("/resetpassword/:id/:email",validate(Validators.RestPassword)
 ,asyncWrapper(async function (req, res) {
    let encodedId = req.params.id;
    let encodedEmail = req.params.email;
    let password = req.body.password;
    switch (await manager.RestUserPassword(encodedId,encodedEmail,password))
    {
        case SqlStatus.Secucces:
            return res.status(200).send("password has been reseted seccsusfuly");
        case SqlStatus.ArgumentsError:
            return res.status(400).send("invalid request");
    }
}));

router.post("/sendresetemail",validate(Validators.SendRestPasswordMail),
asyncWrapper(async function (req, res) {
    let username = req.body.username;
    switch (await manager.SendResetEmail(username))
    {
        case SqlStatus.Seccuss:
            return res.status(200).send("mail sent");
        case SqlStatus.ArgumentsError:
            return res.status(400).send("invalid username");
    }
}));

module.exports = router;