const jwt = require('jsonwebtoken');
const conf = global.gConfig.JWT;
const JwtOptions =
{
    algorithm: conf.algoritem,
    issuer: conf.iss,
    audience: conf.aud,
}

function create(sub, customeData = {}) {
    let pyload = {
        sub: sub,
        iat: (Date.now() / 1000),
        exp: ((Date.now() / 1000) + (conf.ttl * 60)),
        ...customeData
    };

    return jwt.sign(pyload, conf.key, JwtOptions);
}


function validateAndGet(token) {
    try {
        return jwt.verify(token, secretOrPublicKey, JwtOptions);
    }
    catch(err) {
        return null;
    }
}

function DecodeOnly(token)
{
    return jwt.decode(token);
}

module.exports ={create, validateAndGet, DecodeOnly};