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
CREATE PROCEDURE SaveStudentAnswers
	@StudentExamId int,
	@QuestionId int,
	@AnswerIds AS IdList readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- adds only valid answers
		INSERT INTO StudentTestAnswers (StudentTestId,QuestionId,AnswerId)
		SELECT @StudentExamId,@QuestionId, Id 
		FROM Answers WHERE QuestionId = QuestionId AND Id IN (SELECT ID FROM @AnswerIds);
END
GO
