function validateOrganization(req, res, next) {
    let orgId;
    try {
        orgId = parseInt(req.params.org);
    }
    catch (err) {
        res.sendStatus(400);
        return;
    }
    if (req.token.organizations.map(org=>org.Id).includes(orgId)) {
        next();
    }
    else {
        res.sendStatus(403);
    }
}

module.exports = validateOrganization;