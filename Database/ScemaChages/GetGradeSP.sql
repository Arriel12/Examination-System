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
CREATE PROCEDURE GetGrade
	@StudentExamId int,
	@FullData bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @ExamId uniqueidentifier, @Grade tinyint, @studentId int;
	
	--Get student test data
	SELECT @ExamId = ExamId, @Grade = Grade, @studentId = StudentId
	FROM StudentTests 
	WHERE Id = @StudentExamId;

	--Calculate grade if missing (and lock the test)
	IF (@Grade = NULL)
	BEGIN
		DECLARE @CourectCount tinyint, @QuestionCount tinyint;
		SELECT @CourectCount = COUNT(qa.Id)
		FROM
			(SELECT sa.QuestionId, SUM(CAST(an.IsCorrect AS INT)) AS CorrectAnswers,
				SUM(CASE WHEN an.IsCorrect = 0 THEN 1 ELSE 0 END) AS WrongAnswers 
			FROM StudentTestAnswers AS sa
			INNER JOIN Answers AS an ON sa.AnswerId = an.Id AND sa.QuestionId = an.QuestionId
			GROUP BY sa.QuestionId)  AS qs
		INNER JOIN Questions AS qa ON qs.QuestionId = qa.Id
		WHERE qs.WrongAnswers = 0 AND qs.CorrectAnswers = qa.CorrectCount;

		SELECT @QuestionCount = COUNT(QuestionId) 
		FROM ExamsQuestions 
		WHERE ExamId = @ExamId;

		SET @Grade = CAST(ROUND(@CourectCount * (100.0/@QuestionCount),0) AS tinyint);

		UPDATE StudentTests 
		SET Grade = @Grade 
		WHERE Id = @StudentExamId;

	END
	--returns requied data
	IF (@FullData =1)
	BEGIN
		SELECT @Grade AS Grade,
			CASE WHEN @Grade<PassingGrade THEN FailText ELSE SuccessText END AS [Text], 
			CASE WHEN @Grade<PassingGrade THEN FailMailSubject ELSE SuccessMailSubject END AS [Subject],
			CASE WHEN @Grade<PassingGrade THEN FailMailBody ELSE SuccessMailBody END AS Body, 
			CASE WHEN @Grade<PassingGrade THEN 0 ELSE 1 END AS Passed,
			CertificateUrl,OrganaizerEmail, ShowAnswer, PassingGrade
		FROM  Exams WHERE Id = @ExamId;
	END
	ELSE
	BEGIN
		SELECT @Grade AS Grade,	CASE WHEN @Grade<PassingGrade THEN 0 ELSE 1 END AS Passed,
		PassingGrade
		FROM  Exams WHERE Id = @ExamId;
	END
    
END
GO
