USE [examsDb]
GO
/****** Object:  StoredProcedure [dbo].[GetExamStudent]    Script Date: 2/6/2019 9:10:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetExamStudent]
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

	SELECT an.QuestionId,an.Id,an.IsCorrect
	FROM Answers AS an
	INNER JOIN ExamsQuestions AS eq ON an.QuestionId = eq.QuestionId
	WHERE eq.ExamId = @ExamId
	ORDER BY an.QuestionId;
END
