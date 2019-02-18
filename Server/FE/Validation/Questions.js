var Joi = require('joi');

const newQuestion =
{
    body: {
        question: Joi.string().required(),
        textBelow: Joi.string().required(),
        isMultipleChoice: Joi.boolean().required(),
        isHorizontal: Joi.boolean().required(),
        tags: Joi.string().required(),
        answers: Joi.array().items(Joi.object().keys({
            answer: Joi.string().required(),
            isCorrect: Joi.boolean().required()
        })).min(2).required()
      }
};


module.exports ={newQuestion};