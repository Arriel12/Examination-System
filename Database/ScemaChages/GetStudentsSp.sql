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
CREATE PROCEDURE GetStudents
	@organizationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT st.FirstName,st.LastName,st.Email,st.Phone,
		FIRST_VALUE (se.HandedOn) OVER (PARTITION BY st.EMAIL ORDER BY se.HandedOn DESC) AS lastActivity
	FROM Students AS st
	INNER JOIN StudentTests AS se ON se.StudentId = st.Email
	INNER JOIN Exams AS ex ON ex.Id = se.ExamId
	WHERE ex.OrganizationId = @organizationId AND se.HandedOn IS NOT NULL;
END
GO
