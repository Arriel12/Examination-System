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
CREATE PROCEDURE ListQuestions
	@CategoryId int,
	@OrganizationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT qu.Id, qu.Question, qu.Tags,qu.UpdatedOn, qu.IsMultipleChoice, COUNT(eq.ExamId) AS Exams
	FROM Questions AS qu
	INNER JOIN QuestionsCategories AS qc ON qc.QuestionId = qu.Id AND qc.CategoryId = @CategoryId 
	INNER JOIN Categories AS cat ON cat.Id = qc.CategoryId AND cat.OrganizationId = @OrganizationId
	LEFT JOIN ExamsQuestions AS eq ON qu.Id = eq.QuestionId
	GROUP BY qu.Id, qu.Question, qu.Tags,qu.UpdatedOn, qu.IsMultipleChoice;
END
GO
