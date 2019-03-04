var Joi = require('joi');

const newQuestion =
{
    body: {
        question: Joi.string().required(),
        textBelowQuestion: Joi.string().required(),
        isMultipleChoice: Joi.boolean().required(),
        isHorizontal: Joi.boolean().required(),
        tags: Joi.string().required(),
        answers: Joi.array().items(Joi.object().keys({
            Answer: Joi.string().required(),
            IsCorrect: Joi.boolean().required()
        })).min(2).required()
      }
};

const updateQuestion ={
    body:{
        question: Joi.string().optional(),
        textBelow: Joi.string().optional(),
        isMultipleChoice: Joi.boolean().required(),
        isHorizontal: Joi.boolean().optional(),
        tags: Joi.string().optional(),
        answers: Joi.array().items(Joi.object().keys({
            Answer: Joi.string().required(),
            IsCorrect: Joi.boolean().required(),
            Id: Joi.number().integer().optional()
        })).min(2).required()
    }
}

module.exports ={newQuestion,updateQuestion};