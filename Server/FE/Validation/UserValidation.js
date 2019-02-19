var Joi = require('joi');

const Login = {
    body: {
        username: Joi.string().required(),
        password: Joi.string().required()
    }
};

const Register ={
    body:{
        username: Joi.string().required(),
        password: Joi.string().required()
    }
}

const RestPassword ={
    body:{
        password: Joi.string().required()
    }
}

const SendRestPasswordMail ={
    body:{
        username: Joi.string().required()
    }
}

module.exports = { Login,Register,RestPassword,SendRestPasswordMail};