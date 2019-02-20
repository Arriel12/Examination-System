const express = require('express');
const router = express.Router();

const authentication = require('../Middaleware/Autentication.js');
const asyncWrapper = require("../Middaleware/AsyncWraper");
const validateOrganization = require("../Middaleware/OrganizationValidation");

const CategoriesManager = require("../../BL/Managers/CategoriesManager.js");
const manager = new CategoriesManager();


router.use(authentication);

router.get('/:org', validateOrganization,
    asyncWrapper(async function (req, res) {
        let orgId = req.params.org;
        let results = await manager.GetCategoriesByOrganization(orgId);
        res.status(200).send(results);
    }));

    module.exports = router;