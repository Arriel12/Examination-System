USE [examsDb]
GO
/****** Object:  StoredProcedure [dbo].[CreateQuestion]    Script Date: 2/18/2019 11:21:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CreateQuestion]
	@Question nvarchar(2000),
	@TextBelowQuestion nvarchar(2000),
	@IsMultipleChoice bit,
	@IsHorizontal bit,
	@Tags nvarchar(2000),
	@CorrectCount tinyint,
	@OrganizationId int,
	@Answers AS Answers readonly,
	@Categories AS IdList readonly
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

			INSERT INTO QuestionsCategories (QuestionId,CategoryId)
			SELECT @questionId,ID
			FROM @Categories;

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH;

END
