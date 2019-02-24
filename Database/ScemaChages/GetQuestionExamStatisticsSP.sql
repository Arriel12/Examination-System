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
CREATE PROCEDURE GetQuestionExamStatistics
@ExamId int,
@StartDate datetime,
@Enddate datetime,
@QuestionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT an.Id,an.IsCorrect,an.QuestionId,COUNT(sa.StudentTestId) AS Selected
	FROM Answers AS an
	LEFT JOIN (
		SELECT sta.AnswerId,sta.QuestionId,sta.StudentTestId
		FROM StudentTestAnswers AS sta 
		INNER JOIN StudentTests AS se ON se.ExamId = @ExamId AND 
			(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
			(@Enddate IS NULL OR se.HandedOn<= @Enddate) AND
			se.Id = sta.StudentTestId) AS sa ON sa.AnswerId=an.Id AND
			 sa.QuestionId = an.Id 
	WHERE an.QuestionId = @QuestionId 
	GROUP BY an.Id,an.IsCorrect,an.QuestionId

END
GO
