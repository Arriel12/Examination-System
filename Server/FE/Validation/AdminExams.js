var Joi = require('joi');
 
const newExam = {
  body: {
    language: Joi.string().regex(/^hebrew|english$/).required(),
    name: Joi.string().max(200).required(),
    openningText: Joi.string().required(),
    orgenaizerEmail: Joi.string().email().optional(),
    passingGrade: Joi.number().integer().required(),
    showAnswer: Joi.bool().required(),
    certificateUrl: Joi.string().optional(),
    successText: Joi.string().required(),
    failText: Joi.string().required(),
    successMailSubject: Joi.string().optional(),
    successMailBody: Joi.string().optional(),
    failMailSubject: Joi.string().optional(),
    failMailBody: Joi.string().optional(),
    questionsIds:Joi.array().items(Joi.number().integer()).min(1).required()
  }
};

const UpdateExam = {
    body: {
      language: Joi.string().regex(/^hebrew|english$/).optional(),
      name: Joi.string().max(200).optional(),
      openningText: Joi.string().optional(),
      orgenaizerEmail: Joi.string().email().optional(),
      passingGrade: Joi.number().integer().optional(),
      showAnswer: Joi.bool().optional(),
      certificateUrl: Joi.string().optional(),
      successText: Joi.string().optional(),
      failText: Joi.string().optional(),
      successMailSubject: Joi.string().optional(),
      successMailBody: Joi.string().optional(),
      failMailSubject: Joi.string().optional(),
      failMailBody: Joi.string().optional(),
      questionsIds:Joi.array().items(Joi.number().integer()).min(1).required()
    }
  };


module.exports ={newExam,UpdateExam};