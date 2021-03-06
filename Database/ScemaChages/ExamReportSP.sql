USE [examsDb]
GO
/****** Object:  StoredProcedure [dbo].[ExamBasedReport]    Script Date: 2/21/2019 2:43:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ExamBasedReport]
@ExamId int,
@StartDate datetime,
@Enddate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- exam statistics
	SELECT  ex.Id,ex.[Name], ex.PassingGrade, COUNT(DISTINCT eq.QuestionId) AS Questions,
	AVG(se.Grade) AS AvarageGrade, COUNT(DISTINCT se.Id) AS Submisions,
	count(distinct (case when  ex.PassingGrade <= se.Grade  then se.Grade end)) AS Passing
	FROM Exams AS ex 
	INNER JOIN ExamsQuestions AS eq ON eq.ExamId = ex.Id
	LEFT JOIN StudentTests AS se ON se.ExamId = ex.Id
	WHERE ex.Id = @ExamId AND (se.Id IS NULL OR se.Grade IS NOT NULL)
	GROUP BY ex.Id,ex.[Name], ex.PassingGrade, eq.QuestionId

	--exam median
	SELECT AVG(Grade) AS Median
	FROM
		(SELECT se.Id,se.Grade,
		  ROW_NUMBER() OVER (PARTITION BY se.Id
			 ORDER BY se.Grade ASC, se.Id ASC) AS RowAsc,
		  ROW_NUMBER() OVER (PARTITION BY se.Id
			 ORDER BY se.Grade DESC, se.Id DESC) AS RowDesc
	   FROM StudentTests AS se
	   WHERE se.ExamId = @ExamId AND (se.Id IS NULL OR se.Grade IS NOT NULL)) AS sm
	WHERE
	   RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1)
	GROUP BY Id
	ORDER BY Id;

	-- student grades
	SELECT CONCAT(st.FirstName,' ',st.LastName) AS FullName,se.HandedOn,
	COUNT(DISTINCT sa.QuestionId) AS SentQuestions ,se.Grade, se.Id
	FROM Exams AS ex
	INNER JOIN StudentTests AS se ON se.ExamId = ex.Id 
	INNER JOIN Students AS st ON st.Email = se.StudentId
	LEFT JOIN StudentTestAnswers AS sa ON sa.StudentTestId = se.Id 
	WHERE ex.Id = @ExamId AND 
		(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
		(@Enddate IS NULL OR se.HandedOn<= @Enddate) AND
		 (se.Id IS NULL OR se.Grade IS NOT NULL)
	GROUP BY st.FirstName,st.LastName,se.HandedOn,se.Grade,se.Id

	--question statistics
		SELECT qu.Id,qu.Question,qu.Tags,
		SUM(CASE WHEN qs.WrongAnswers = 0 AND qs.CorrectAnswers = qu.CorrectCount THEN 1 ELSE 0 END) AS courrectCount,
		COUNT(qs.StudentTestId) AS TotalCount
	FROM Exams AS ex 
	INNER JOIN ExamsQuestions AS eq ON eq.ExamId = ex.Id
	INNER JOIN Questions AS qu ON qu.Id = eq.QuestionId
	 LEFT JOIN (
		SELECT sa.QuestionId, SUM(CAST(an.IsCorrect AS INT)) AS CorrectAnswers,
				SUM(CASE WHEN an.IsCorrect = 0 THEN 1 ELSE 0 END) AS WrongAnswers,
				sa.StudentTestId 
		FROM StudentTests AS se
		INNER JOIN StudentTestAnswers AS sa ON sa.StudentTestId = se.Id
		INNER JOIN Answers AS an ON sa.AnswerId = an.Id AND sa.QuestionId = an.QuestionId
		WHERE se.ExamId = @ExamId AND se.Grade IS NOT NULL AND 
		(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
		(@Enddate IS NULL OR se.HandedOn<= @Enddate)
		GROUP BY sa.QuestionId,sa.StudentTestId)  AS qs	ON qs.QuestionId = qu.Id 
	WHERE ex.Id = @ExamId 
	GROUP BY qu.Id,qu.Question,qu.Tags

END
