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
CREATE PROCEDURE CreateStudentIfNotExsists
	-- Add the parameters for the stored procedure here
	@studentEmail varchar(50),
	@studentPhone varchar(15),
	@studentFirstName nvarchar(20),
	@studentLastName nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM Students WHERE Email = @studentEmail)
    BEGIN
        INSERT INTO Students (Email,Phone,FirstName,LastName)
	VALUES (@studentEmail,@studentPhone,@studentFirstName,@studentLastName)
    END;
END
GO
