const express = require('express');
const router = express.Router();
const validate = require('express-validation')

const authentication = require('../Middaleware/Autentication.js');
const asyncWrapper = require("../Middaleware/AsyncWraper");
const validateOrganization = require("../Middaleware/OrganizationValidation");

const Validators = require("../Validation/Questions.js");
const QuestionsManager = require("../../BL/Managers/QuestionsManager.js");
const manager = new QuestionsManager();


router.use(authentication);

router.post('/:org/:category', validateOrganization, validate(Validators.newQuestion),
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let question = req.body
        question.categories = [req.params.category];
        let results = await manager.CreateQuestion(question, orgId);
        res.status(200).send(results);
    }));

router.get('/:org/:category', validateOrganization,
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let categoryId =req.params.category;
        let results = await manager.ListQuestions(question, orgId);
        res.status(200).send(results);
    }));

module.exports = router;