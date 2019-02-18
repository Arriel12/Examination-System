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
CREATE PROCEDURE CreateQuestion
	@Question nvarchar(2000),
	@TextBelowQuestion nvarchar(2000),
	@IsMultipleChoice bit,
	@IsHorizontal bit,
	@Tags nvarchar(2000),
	@CorrectCount tinyint,
	@OrganizationId int,
	@Answers AS Answers readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @questionId int;
	BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO	Questions (Question,TextBelowQuestion,Tags,CorrectCount,OrganizationId,IsHorizontal,IsMultipleChoice) 
			VALUES(@Question,@TextBelowQuestion,@Tags,@CorrectCount,@OrganizationId,@IsHorizontal,@IsMultipleChoice);

			SET @questionId = SCOPE_IDENTITY();

			INSERT INTO Answers (QuestionId,Answer,IsCorrect)
			SELECT @questionId, Answer,IsCorrect
			FROM @Answers;
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH;

END
GO
