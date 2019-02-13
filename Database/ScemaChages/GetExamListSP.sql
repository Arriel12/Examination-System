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
CREATE PROCEDURE GetExamsList
	@OrganizationId int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ex.Id,ex.[Name], COUNT(eq.QuestionId) AS Questions,
		(CASE WHEN COUNT(st.Id) = 0 THEN 0 ELSE 1 END) AS IsActive
	FROM Exams AS ex
	LEFT JOIN ExamsQuestions AS eq ON eq.ExamId = ex.Id
	LEFT JOIN StudentTests AS st ON st.ExamId = ex.Id
	WHERE ex.OrganizationId = @OrganizationId
	GROUP BY ex.Id,ex.[Name]
END
GO
