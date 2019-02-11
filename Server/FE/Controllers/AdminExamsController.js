const express = require('express');
const router = express.Router();
const authentication = require('../Middaleware/Autentication.js');
const validate = require('express-validation')

const Validators = require("../Validation/AdminExams.js");
const AdminExamsManager = require("../../BL/Managers/AdminExamsManager.js");
const manager = new AdminExamsManager();

const asyncWrapper = require("../Middaleware/AsyncWraper");

router.use(authentication);

router.get('/:org', _validateOrganization,
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let results = await manager.ListExams(orgId);
        res.status(200).send(results);
    }));

router.post('/:org/Create', _validateOrganization, validate(Validators.newExam),
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let results = await manager.CreateExam(orgId, req.body);
        res.status(200).send(results);
    }));

router.get('/:org/:examId', _validateOrganization,
    asyncWrapper(async function (req, res) {
        let examId = req.params.examId;
        let exam = await manager.GetExam(examId);
        res.status(200).send(exam);
    }));

router.post('/:org/:examId', _validateOrganization, validate(Validators.UpdateExam),
    asyncWrapper(async function (req, res) {
        let examId = req.params.examId;
        let data = req.body;
        await manager.UpdateExam(examId, data)
    }));

function _validateOrganization(req, res, next) {
    let orgId;
    try {
        orgId = parseInt(req.params.org);
    }
    catch (err) {
        res.sendStatus(400);
        return;
    }
    if (req.token.organizations.includes(orgId)) {
        next();
    }
    else {
        res.sendStatus(403);
    }
}



module.exports = router;