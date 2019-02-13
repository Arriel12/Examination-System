
CREATE TYPE dbo.IDList
AS TABLE
(
  ID INT
);
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
CREATE PROCEDURE CreateExam
	-- Add the parameters for the stored procedure here
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
	
	
    -- generate id
	Declare @Id uniqueidentifier;
	SET @Id = NEWID();
	-- create exam
	INSERT INTO Exams (Id,[Language],[Name],OpeningText,OrganaizerEmail,PassingGrade,ShowAnswer,CertificateUrl,
	SuccessText,FailText,SuccessMailSubject,SuccessMailBody,FailMailSubject,FailMailBody,OrganizationId)
	VALUES (@Id,@Language,@Name,@OpenningText,@OrgenaizerEmail,@PassingGrade,@ShowAnswer,@CertificateUrl,
	@SuccessText,@FailText,@SuccessMailSubject,@SuccessMailBody,@FailMailSubject,@FailMailBody,dbo.GetAdminOrganization(@UserId));
	-- add questions
	INSERT INTO ExamsQuestions (ExamId,QuestionId)
		SELECT @Id,ID FROM @QuestionsIds;
	-- returns exam id
	SELECT @id AS ExamId;
END
GO
