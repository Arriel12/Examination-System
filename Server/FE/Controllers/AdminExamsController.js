const express = require('express');
const router = express.Router();
const authentication = require('../Middaleware/Autentication.js');
const validate = require('express-validation')

const Validators = require("../Validation/AdminExams.js");
const AdminExamsManager = require("../../BL/Managers/AdminExamsManager.js");
const manager = new AdminExamsManager();


router.use(authentication);

router.get('/:org', _validateOrganization, function (req, res) {
    let orgId = req.params.org;
    try {
        let results = manager.ListExams(orgId);
        res.status(200).send(results);
    }
    catch
    {
        res.sendStatus(500);
    }
});

router.post('/:org/Create', _validateOrganization,validate(Validators.newExam),function (req,res){
    let orgId = req.params.org;
    let results = manager.CreateExam(orgId,req.body);
    res.status(200).send(results);
    
});

router.get('/:org/:examId',_validateOrganization,function (req,res)
{
    let examId = req.params.examId;
    let exam = manager.GetExam(examId);
    res.status(200).send(exam);
});

router.post('/:org/:examId',_validateOrganization,validate(Validators.UpdateExam),function(req,res)
{
    let examId = req.params.examId;
    let data = req.body;
    manager.UpdateExam(examId,data)
})

function _validateOrganization(req, res, next) {
    let orgId = req.params.org;
    if (req.token.organizations.includes(orgId)) {
        next();
    }
    else {
        res.sendStatus(403);
    }
}



module.exports = router;