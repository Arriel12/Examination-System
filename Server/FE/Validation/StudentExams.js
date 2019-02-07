var Joi = require('joi');
 
const newExam = {
  body: {
    email: Joi.string().email().required(),
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    phone: Joi.string().regex('^(\+972|0)5{0,1}\d{8}$')
  }
};

const answer = {
  body: {
    questionId : Joi.number().required(),
    answers : Joi.array().items(Joi.number()).required()
  }
}

module.exports ={newExam,answer};