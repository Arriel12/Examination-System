const express = require('express');
const router = express.Router();
const validate = require('express-validation')

const authentication = require('../Middaleware/Autentication.js');
const asyncWrapper = require("../Middaleware/AsyncWraper");

const LoginStatues = require("../../Common/Enums/LoginStatus.js");
const Validators = require("../Validation/UserValidation.js");
const UsersManager = require("../../BL/Managers/UsersManager");
const manager = new UsersManager();


router.post("/login",validate(Validators.Login),asyncWrapper(async function (req, res) {
    let loginRes = await manager.Login(req.body.username,req.body.password);
    switch (loginRes.status)
    { 
        case LoginStatues.Secucces:
            return res.set("x-token",loginRes.jwt).sendStatus(200);
        case LoginStatues.WorngUserNameOrPassword:
            return res.status(401).send("invalid username or password");
        case LoginStatues.UnVerified:
            return res.status(400).send("user hasn't been validated");
    }
}));

module.exports = router;