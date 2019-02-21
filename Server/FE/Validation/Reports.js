var Joi = require('joi');

const Exam ={
    body: {
        examId: Joi.number().integer().positive().required(),
        startDate: Joi.date().optional(),
        endDate: Joi.date().optional()
      }
};

const Student ={
    body: {
        studentEmail: Joi.string().email().required()
      }
};

const QuestionStatistics ={
    body: {
        examId: Joi.number().integer().positive().required(),
        startDate: Joi.date().optional(),
        endDate: Joi.date().optional(),
        questionId: Joi.number().integer().positive().required()
      }
};

const StudentAnswers ={
    body: {
        studentExamId: Joi.number().integer().required()
      }
};

module.exports ={Exam,Student,QuestionStatistics,StudentAnswers};