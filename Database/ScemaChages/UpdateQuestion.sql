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
CREATE PROCEDURE UpdateQuestion
	@OrganizationId int,
	@CategoryId int,
	@QuestionId int,
	@IsHorizontal bit,
	@IsMultipleChoice bit,
	@Question nvarchar(2000),
	@Tags nvarchar(2000),
	@TextBelowQuestion nvarchar(2000),
	@CorrectCount tinyint,
	@Answers AS AnswerUpdate readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET NOCOUNT ON;
	BEGIN TRANSACTION;
		BEGIN TRY

			IF(Exists(SELECT TOP 1 1 FROM ExamsQuestions WHERE QuestionId = @QuestionId))
			BEGIN
				UPDATE Questions
				SET IsHorizontal =COALESCE(@IsHorizontal,IsHorizontal),
					IsMultipleChoice=COALESCE(@IsMultipleChoice,IsMultipleChoice),
					Question =COALESCE(@Question,Question),
					Tags=COALESCE(@Tags,Tags),
					TextBelowQuestion=COALESCE(@TextBelowQuestion,TextBelowQuestion),
					CorrectCount=COALESCE(@CorrectCount,CorrectCount)
				WHERE Id = @QuestionId AND OrganizationId = @OrganizationId AND
					EXISTS(SELECT 1 FROM QuestionsCategories WHERE QuestionId= @QuestionId AND CategoryId =@CategoryId);

				DELETE FROM Answers
				WHERE Id NOT IN (SELECT Id FROM Answers);

				UPDATE Answers
				SET
					Answers.Answer = COALESCE(an.Answer,Answers.Answer),
					Answers.IsCorrect = COALESCE(an.IsCorrect,Answers.IsCorrect)
				FROM
					@Answers AS an
				WHERE Answers.Id = an.Id AND Answers.QuestionId = @QuestionId

				INSERT INTO Answers (QuestionId,Answer,IsCorrect)
					SELECT @QuestionId,Answer,IsCorrect 
					FROM @Answers AS an
					WHERE NOT EXISTS( SELECT * FROM Answers WHERE Id =  an.Id AND QuestionId = @QuestionId);
			END
			ELSE
				SELECT 'question is active' AS Error;

			COMMIT TRANSACTION;
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH;


END
GO
