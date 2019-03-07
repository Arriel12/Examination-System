const express = require('express');
const router = express.Router();
const validate = require('express-validation');

const authentication = require('../Middaleware/Autentication.js');
const _validateOrganization = require("../Middaleware/OrganizationValidation");
const asyncWrapper = require("../Middaleware/AsyncWraper");

const Validators = require("../Validation/AdminExams.js");
const AdminExamsManager = require("../../BL/Managers/AdminExamsManager.js");

const manager = new AdminExamsManager();


router.use(authentication);

router.get('/:org/:category', _validateOrganization,
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let catId = req.params.category;
        let results = await manager.ListExams(orgId, catId);
        res.status(200).send(results);
    }));

router.post('/:org/:category/Create', _validateOrganization, validate(Validators.newExam),
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let catId = req.params.category;
        let results = await manager.CreateExam(orgId, catId, req.body);
        res.status(200).send(results);
    }));

router.get('/:org/:category/:examId', _validateOrganization,
    asyncWrapper(async function (req, res) {
        let examId = req.params.examId;
        let exam = await manager.GetExam(examId);
        res.status(200).send(exam);
    }));

router.post('/:org/:category/:examId', _validateOrganization, validate(Validators.UpdateExam),
    asyncWrapper(async function (req, res) {
        let examId = req.params.examId;
        try {
            examId= parseInt(examId);
            if (examId) {
                let data = req.body;
                await manager.UpdateExam(examId, data)
                res.status(200).send({});
            }
            else
            res.status(400).send({error:'invalid request'});
        } catch (error) {
            res.status(400).send({error:'invalid request'});
        }
    }));

router.delete('/:org/:category/:examId', _validateOrganization,
    asyncWrapper(async function (req, res) {
        let examId = req.params.examId;
        let org = req.params.org;
        let category = req.params.category;
        await manager.DeleteExam(examId, org, category);
        res.sendStatus(200);
    }));


module.exports = router;