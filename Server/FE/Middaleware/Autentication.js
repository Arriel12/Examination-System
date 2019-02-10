const validateAndGet = require("../../BL/Helpers/JWT.js").validateAndGet;

function autenticate (req,res,next)
{
    let token = req.get("Authorization").split(' ')[1];
    let paylod = validateAndGet(token);
    if(paylod!= null)
    {
        req.token = paylod;
        next();
    }
    else
    {
        res.status(401).send('Invalid Acsses Token');
    }
}
module.exports = autenticate;