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
CREATE PROCEDURE UpdateExam
	@ExamId uniqueIdentifier,
	@Language varchar(10),
	@Name nvarchar(200),
	@OpenningText nvarchar(2000),
	@OrgenaizerEmail nvarchar(50),
	@PassingGrade tinyint,
	@ShowAnswer bit,
	@CertificateUrl varchar(255),
	@SuccessText nvarchar(2000),
	@FailText nvarchar(2000),
	@SuccessMailSubject nvarchar(255),
	@SuccessMailBody nvarchar(2000),
	@FailMailSubject nvarchar(255),
	@FailMailBody nvarchar(2000),
	@QuestionsIds AS dbo.IDList READONLY,
	@UserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE Exams SET 
		[Language] = COALESCE(@Language,[Language]),
		[Name] =  COALESCE(@Name,[Name]),
		OpeningText = COALESCE(@OpenningText,[Name]),
		OrganaizerEmail = COALESCE(@OrgenaizerEmail,[Language]),
		PassingGrade = COALESCE(@PassingGrade,[Language]),
		ShowAnswer = COALESCE(@ShowAnswer,[Language]),
		CertificateUrl = COALESCE(@CertificateUrl,[Language]),
		SuccessText = COALESCE(@SuccessText,[Language]),
		FailText = COALESCE(@FailText,[Language]),
		SuccessMailSubject = COALESCE(@SuccessMailSubject,[Language]),
		SuccessMailBody = COALESCE(@SuccessMailBody,[Language]),
		FailMailSubject = COALESCE(@FailMailSubject,[Language]),
		FailMailBody = COALESCE(@FailMailBody,[Language])
	WHERE Id = @ExamId;
	-- removed removed questions questions
	Delete FROM ExamsQuestions WHERE ExamId = @ExamId AND 
		QuestionId NOT IN (SELECT ID FROM @QuestionsIds);
	-- add missing questions
	INSERT INTO ExamsQuestions (ExamId,QuestionId)
		SELECT @ExamId,ID FROM @QuestionsIds
		WHERE NOT EXISTS( SELECT * FROM ExamsQuestions WHERE ExamId = @ExamId AND  QuestionId = ID);
END
GO

