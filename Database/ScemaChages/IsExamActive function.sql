-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION IsExamActive
(
	@ExamId uniqueidentifier
)
RETURNS bit
AS
BEGIN
	
	DECLARE @exists bit
	SELECT TOP 1  @exists = Convert(BIT, count(ExamId)) 
	FROM StudentTests
	WHERE ExamId = @ExamId
	
	-- Return the result of the function
	RETURN @exists

END
GO

