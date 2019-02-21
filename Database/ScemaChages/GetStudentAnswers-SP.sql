-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetStudentAnswers 
	@StudentExamId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--questions
    SELECT qu.Question,qu.Id
	FROM Questions AS qu
	INNER JOIN QuestionsOrder AS qo ON qo.QuestionId = qu.Id AND qo.StudentTestId =@StudentExamId
	ORDER BY qo.QuestionIndex
	
	--answers
	SELECT an.Answer,an.IsCorrect,an.QuestionId, (CASE WHEN sta.AnswerId IS NULL THEN 0 ELSE 1 END) AS IsSelected 
	FROM Answers AS an
	INNER JOIN AnswersOrder AS ao ON ao.AnswerId = an.Id AND ao.QuestionId = an.QuestionId AND
		 ao.StudentTestId = @StudentExamId
	INNER JOIN QuestionsOrder AS qo ON qo.QuestionId = ao.QuestionId AND qo.StudentTestId =@StudentExamId
	LEFT JOIN StudentTestAnswers AS sta ON sta.AnswerId = an.Id AND sta.QuestionId = an.Id AND 
		sta.StudentTestId = @StudentExamId 
	ORDER BY qo.QuestionIndex,ao.AnswerIndex 
END
GO
