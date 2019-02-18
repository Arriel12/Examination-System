var Joi = require('joi');

const Login = {
    body: {
        username: Joi.string().required(),
        password: Joi.string().required()
    }
};

module.exports = { Login};