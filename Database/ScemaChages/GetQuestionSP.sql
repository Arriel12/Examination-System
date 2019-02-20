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
CREATE PROCEDURE GetQuestion
	@OrganizationId int,
	@CategoryId int,
	@QuestionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT qu.Id,qu.IsHorizontal,qu.IsHorizontal,qu.OrganizationId,qu.Question,qu.Tags,qu.TextBelowQuestion,qu.UpdatedOn
	FROM Questions AS qu
	WHERE qu.Id = @QuestionId AND qu.Id IN (SELECT QuestionId FROM QuestionsCategories WHERE CategoryId =@CategoryId) 
	AND qu.OrganizationId = @OrganizationId;
	
	IF (@@ROWCOUNT>0) 
		SELECT an.Id,an.QuestionId,an.Answer,an.IsCorrect
		FROM Answers AS an
		WHERE an.QuestionId = @QuestionId;
	
END
GO
