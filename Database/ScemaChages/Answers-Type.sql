-- ================================
-- Create User-defined Table Type
-- ================================
USE examsDb
GO

-- Create the data type
CREATE TYPE Answers AS TABLE 
(
	Answer nvarchar(1000),
	IsCorrect bit
)
GO
