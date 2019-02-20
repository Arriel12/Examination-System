const express = require('express');
const router = express.Router();
const validate = require('express-validation')

const authentication = require('../Middaleware/Autentication.js');
const asyncWrapper = require("../Middaleware/AsyncWraper");
const validateOrganization = require("../Middaleware/OrganizationValidation");

const Validators = require("../Validation/Questions.js");
const SqlStatus = require("../../Common/Enums/SqlStatus.js");
const QuestionsManager = require("../../BL/Managers/QuestionsManager.js");
const manager = new QuestionsManager();


router.use(authentication);

router.post('/:org/:category', validateOrganization, validate(Validators.newQuestion),
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let question = req.body
        question.categories = [req.params.category];
        let results = await manager.CreateQuestion(question, orgId);
        if (results === SqlStatus.ArgumentsError)
            res.status(400).send("invalid amount of correct questions");
        else
            res.status(200).send(results);
    }));

router.get('/:org/:category', validateOrganization,
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let categoryId = req.params.category;
        let results = await manager.ListQuestions(orgId, categoryId);
        res.status(200).send(results);
    }));

router.get('/:org/:category/:question', validateOrganization,
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let categoryId = req.params.category;
        let questionId = req.params.question;
        let results = await manager.GetQuestion(orgId, categoryId, questionId);
        if (results === SqlStatus.ArgumentsError)
            res.status(400).send("invalid parameters was given");
        else
            res.status(200).send(results);
    }));

router.post('/:org/:category/:question', validateOrganization,
    validate(Validators.updateQuestion), asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let categoryId = req.params.category;
        let questionId = req.params.question;
        let results = await manager.UpdateQuestion(orgId, categoryId, questionId,req.body);
        if (results === SqlStatus.ArgumentsError)
            res.status(400).send("invalid parameters was given");
        else
            res.sendStatus(200);
    }));

module.exports = router;