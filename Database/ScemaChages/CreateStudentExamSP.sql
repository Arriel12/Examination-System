CREATE TYPE [dbo].[QuestionOrderList] AS TABLE(
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)

CREATE TYPE [dbo].[AnswersOrderList] AS TABLE(
	[AnswerId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO


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
CREATE PROCEDURE CreateStudentExam
	@ExamId uniqueidentifier,
	@SudentEmail varchar(50),
	@QuestionsOrder AS [QuestionOrderList] Readonly,
	@AnswersOrder AS [AnswersOrderList] Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @StudentTestId int;

	INSERT INTO StudentTests (ExamId,StudentId,HandedOn)
	VALUES (@ExamId,@SudentEmail,GETUTCDATE());

	SET @StudentTestId = SCOPE_IDENTITY();
	
	INSERT INTO QuestionsOrder (StudentTestId,QuestionId,QuestionIndex)
	SELECT @StudentTestId,QuestionId,[Index]
	FROM @QuestionsOrder

	INSERT INTO AnswersOrder (StudentTestId,QuestionId,AnswerId,AnswerIndex)
	SELECT @StudentTestId,QuestionId,AnswerId,[Index]
	FROM @AnswersOrder

	SELECT @StudentTestId;
END
GO
