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
CREATE PROCEDURE GetExamStudent
	@ExamId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  Id,[Language],[Name],OpeningText,PassingGrade
	FROM Exams
	WHERE Id = @ExamId;
	
	SELECT qa.Id,qa.IsHorizontal,qa.IsMultipleChoice,qa.Question,qa.TextBelowQuestion
	FROM Questions AS qa
	INNER JOIN ExamsQuestions AS eq ON qa.Id = eq.QuestionId
	WHERE eq.ExamId = @ExamId 
	ORDER BY qa.Id;

	SELECT an.QuestionId
	FROM Answers AS an
	INNER JOIN ExamsQuestions AS eq ON an.QuestionId = eq.QuestionId
	WHERE eq.ExamId = @ExamId
	ORDER BY an.QuestionId;
END
GO
