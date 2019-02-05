USE [master]
GO
/****** Object:  Database [examsDb]    Script Date: 2/5/2019 3:34:56 PM ******/
CREATE DATABASE [examsDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'examsDb', FILENAME = N'D:\RDSDBDATA\DATA\examsDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'examsDb_log', FILENAME = N'D:\RDSDBDATA\DATA\examsDb_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [examsDb] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [examsDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [examsDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [examsDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [examsDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [examsDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [examsDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [examsDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [examsDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [examsDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [examsDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [examsDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [examsDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [examsDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [examsDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [examsDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [examsDb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [examsDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [examsDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [examsDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [examsDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [examsDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [examsDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [examsDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [examsDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [examsDb] SET  MULTI_USER 
GO
ALTER DATABASE [examsDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [examsDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [examsDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [examsDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [examsDb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [examsDb] SET QUERY_STORE = OFF
GO
USE [examsDb]
GO
/****** Object:  User [ExamSql]    Script Date: 2/5/2019 3:34:58 PM ******/
CREATE USER [ExamSql] FOR LOGIN [ExamSql] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ExamAdmin]    Script Date: 2/5/2019 3:34:58 PM ******/
CREATE USER [ExamAdmin] FOR LOGIN [ExamAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [ExamAdmin]
GO
/****** Object:  UserDefinedTableType [dbo].[AnswersOrderList]    Script Date: 2/5/2019 3:34:59 PM ******/
CREATE TYPE [dbo].[AnswersOrderList] AS TABLE(
	[AnswerId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[IDList]    Script Date: 2/5/2019 3:34:59 PM ******/
CREATE TYPE [dbo].[IDList] AS TABLE(
	[ID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[QuestionOrderList]    Script Date: 2/5/2019 3:34:59 PM ******/
CREATE TYPE [dbo].[QuestionOrderList] AS TABLE(
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetAdminOrganization]    Script Date: 2/5/2019 3:34:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetAdminOrganization]
(	
	@userId int
)
RETURNS int  
begin
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT us.OrganizationId FROM Users AS us WHERE us.UserId = @userId
)
end
GO
/****** Object:  UserDefinedFunction [dbo].[IsExamActive]    Script Date: 2/5/2019 3:34:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[IsExamActive]
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
/****** Object:  Table [dbo].[Answers]    Script Date: 2/5/2019 3:34:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answers](
	[Id] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[IsCorrect] [bit] NOT NULL,
	[Answer] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AnswersOrder]    Script Date: 2/5/2019 3:34:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnswersOrder](
	[StudentTestId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[AnswerId] [int] NOT NULL,
	[AnswerIndex] [tinyint] NOT NULL,
 CONSTRAINT [PK_AnswersOrder] PRIMARY KEY CLUSTERED 
(
	[StudentTestId] ASC,
	[QuestionId] ASC,
	[AnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 2/5/2019 3:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[OrganizationId] [int] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exams]    Script Date: 2/5/2019 3:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exams](
	[Id] [uniqueidentifier] NOT NULL,
	[Language] [varchar](10) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[OpeningText] [nvarchar](2000) NULL,
	[OrganaizerEmail] [nvarchar](50) NULL,
	[PassingGrade] [tinyint] NOT NULL,
	[ShowAnswer] [bit] NOT NULL,
	[CertificateUrl] [varchar](255) NULL,
	[SuccessText] [nvarchar](2000) NULL,
	[FailText] [nvarchar](2000) NULL,
	[SuccessMailSubject] [nvarchar](255) NULL,
	[SuccessMailBody] [nvarchar](2000) NULL,
	[FailMailSubject] [nvarchar](255) NULL,
	[FailMailBody] [nvarchar](2000) NULL,
	[OrganizationId] [int] NOT NULL,
 CONSTRAINT [PK_Exams] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamsQuestions]    Script Date: 2/5/2019 3:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamsQuestions](
	[ExamId] [uniqueidentifier] NOT NULL,
	[QuestionId] [int] NOT NULL,
 CONSTRAINT [PK_ExamsQuestions] PRIMARY KEY CLUSTERED 
(
	[ExamId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 2/5/2019 3:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Organizations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 2/5/2019 3:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[Id] [int] NOT NULL,
	[TextBelowQuestion] [nvarchar](2000) NULL,
	[Question] [nvarchar](2000) NOT NULL,
	[IsMultipleChoice] [bit] NOT NULL,
	[IsHorizontal] [bit] NOT NULL,
	[Tags] [nvarchar](2000) NULL,
	[CorrectCount] [tinyint] NOT NULL,
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsCategories]    Script Date: 2/5/2019 3:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionsCategories](
	[QuestionId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_QuestionsCategories] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsOrder]    Script Date: 2/5/2019 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionsOrder](
	[StudentTestId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[QuestionIndex] [tinyint] NOT NULL,
 CONSTRAINT [PK_QuestionsOrder] PRIMARY KEY CLUSTERED 
(
	[StudentTestId] ASC,
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 2/5/2019 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[Email] [varchar](50) NOT NULL,
	[FirstName] [nvarchar](20) NULL,
	[LastName] [nvarchar](20) NULL,
	[Phone] [varchar](15) NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentTestAnswers]    Script Date: 2/5/2019 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTestAnswers](
	[StudentTestId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[AnswerId] [int] NOT NULL,
 CONSTRAINT [PK_StudentTestAnswers] PRIMARY KEY CLUSTERED 
(
	[StudentTestId] ASC,
	[QuestionId] ASC,
	[AnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentTests]    Script Date: 2/5/2019 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [varchar](50) NOT NULL,
	[Grade] [int] NULL,
	[HandedOn] [date] NULL,
	[ExamId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StudentTests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2/5/2019 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[PasswordHash] [varchar](300) NOT NULL,
	[Verified] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersOrganizations]    Script Date: 2/5/2019 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersOrganizations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[organizationId] [int] NOT NULL,
 CONSTRAINT [PK_UsersOrganizations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exams] ADD  CONSTRAINT [DF_Exams_ShowAnswer]  DEFAULT ((0)) FOR [ShowAnswer]
GO
ALTER TABLE [dbo].[Questions] ADD  CONSTRAINT [DF_Questions_IsHorizontal]  DEFAULT ((0)) FOR [IsHorizontal]
GO
ALTER TABLE [dbo].[Questions] ADD  CONSTRAINT [DF_Questions_CorrectCount]  DEFAULT ((1)) FOR [CorrectCount]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Verified]  DEFAULT ((0)) FOR [Verified]
GO
ALTER TABLE [dbo].[Answers]  WITH CHECK ADD  CONSTRAINT [FK_Answers_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[Answers] CHECK CONSTRAINT [FK_Answers_Questions]
GO
ALTER TABLE [dbo].[AnswersOrder]  WITH CHECK ADD  CONSTRAINT [FK_AnswersOrder_Answers] FOREIGN KEY([AnswerId])
REFERENCES [dbo].[Answers] ([Id])
GO
ALTER TABLE [dbo].[AnswersOrder] CHECK CONSTRAINT [FK_AnswersOrder_Answers]
GO
ALTER TABLE [dbo].[AnswersOrder]  WITH CHECK ADD  CONSTRAINT [FK_AnswersOrder_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[AnswersOrder] CHECK CONSTRAINT [FK_AnswersOrder_Questions]
GO
ALTER TABLE [dbo].[AnswersOrder]  WITH CHECK ADD  CONSTRAINT [FK_AnswersOrder_StudentTests] FOREIGN KEY([StudentTestId])
REFERENCES [dbo].[StudentTests] ([Id])
GO
ALTER TABLE [dbo].[AnswersOrder] CHECK CONSTRAINT [FK_AnswersOrder_StudentTests]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [FK_Categories_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [FK_Categories_Organizations]
GO
ALTER TABLE [dbo].[Exams]  WITH CHECK ADD  CONSTRAINT [FK_Exams_ExamsQuestions] FOREIGN KEY([Id])
REFERENCES [dbo].[ExamsQuestions] ([ExamId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Exams] CHECK CONSTRAINT [FK_Exams_ExamsQuestions]
GO
ALTER TABLE [dbo].[Exams]  WITH CHECK ADD  CONSTRAINT [FK_Exams_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[Exams] CHECK CONSTRAINT [FK_Exams_Organizations]
GO
ALTER TABLE [dbo].[ExamsQuestions]  WITH CHECK ADD  CONSTRAINT [FK_ExamsQuestions_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[ExamsQuestions] CHECK CONSTRAINT [FK_ExamsQuestions_Questions]
GO
ALTER TABLE [dbo].[QuestionsCategories]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsCategories_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[QuestionsCategories] CHECK CONSTRAINT [FK_QuestionsCategories_Categories]
GO
ALTER TABLE [dbo].[QuestionsCategories]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsCategories_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[QuestionsCategories] CHECK CONSTRAINT [FK_QuestionsCategories_Questions]
GO
ALTER TABLE [dbo].[QuestionsOrder]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsOrder_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[QuestionsOrder] CHECK CONSTRAINT [FK_QuestionsOrder_Questions]
GO
ALTER TABLE [dbo].[QuestionsOrder]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsOrder_StudentTests] FOREIGN KEY([StudentTestId])
REFERENCES [dbo].[StudentTests] ([Id])
GO
ALTER TABLE [dbo].[QuestionsOrder] CHECK CONSTRAINT [FK_QuestionsOrder_StudentTests]
GO
ALTER TABLE [dbo].[StudentTestAnswers]  WITH CHECK ADD  CONSTRAINT [FK_StudentTestAnswers_Answers] FOREIGN KEY([AnswerId])
REFERENCES [dbo].[Answers] ([Id])
GO
ALTER TABLE [dbo].[StudentTestAnswers] CHECK CONSTRAINT [FK_StudentTestAnswers_Answers]
GO
ALTER TABLE [dbo].[StudentTestAnswers]  WITH CHECK ADD  CONSTRAINT [FK_StudentTestAnswers_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[StudentTestAnswers] CHECK CONSTRAINT [FK_StudentTestAnswers_Questions]
GO
ALTER TABLE [dbo].[StudentTestAnswers]  WITH CHECK ADD  CONSTRAINT [FK_StudentTestAnswers_StudentTests] FOREIGN KEY([StudentTestId])
REFERENCES [dbo].[StudentTests] ([Id])
GO
ALTER TABLE [dbo].[StudentTestAnswers] CHECK CONSTRAINT [FK_StudentTestAnswers_StudentTests]
GO
ALTER TABLE [dbo].[StudentTests]  WITH CHECK ADD  CONSTRAINT [FK_StudentTests_Exams] FOREIGN KEY([ExamId])
REFERENCES [dbo].[Exams] ([Id])
GO
ALTER TABLE [dbo].[StudentTests] CHECK CONSTRAINT [FK_StudentTests_Exams]
GO
ALTER TABLE [dbo].[StudentTests]  WITH CHECK ADD  CONSTRAINT [FK_StudentTests_Student] FOREIGN KEY([StudentId])
REFERENCES [dbo].[Students] ([Email])
GO
ALTER TABLE [dbo].[StudentTests] CHECK CONSTRAINT [FK_StudentTests_Student]
GO
ALTER TABLE [dbo].[UsersOrganizations]  WITH CHECK ADD  CONSTRAINT [FK_UsersOrganizations_Organizations] FOREIGN KEY([organizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[UsersOrganizations] CHECK CONSTRAINT [FK_UsersOrganizations_Organizations]
GO
ALTER TABLE [dbo].[UsersOrganizations]  WITH CHECK ADD  CONSTRAINT [FK_UsersOrganizations_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UsersOrganizations] CHECK CONSTRAINT [FK_UsersOrganizations_Users]
GO
/****** Object:  StoredProcedure [dbo].[CreateExam]    Script Date: 2/5/2019 3:35:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateExam]
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
/****** Object:  StoredProcedure [dbo].[CreateStudentExam]    Script Date: 2/5/2019 3:35:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateStudentExam]
	@ExamId uniqueidentifier,
	@SudentEmail varchar(50),
	@QuestionsOrder AS [QuestionOrderList] Readonly,
	@AnswersOrder AS [AnswersOrderList] Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @StudentTestId int;

	INSERT INTO StudentTests (ExamId,StudentId,HandedOn)
	VALUES (@ExamId,@SudentEmail,GETUTCDATE());

	SET @StudentTestId = SCOPE_IDENTITY();
	
	INSERT INTO QuestionsOrder (StudentTestId,QuestionId,QuestionIndex)
	SELECT @StudentTestId,QuestionId,[Index]
	FROM @QuestionsOrder

	INSERT INTO AnswersOrder (StudentTestId,QuestionId,AnswerId,AnswerIndex)
	SELECT @StudentTestId,QuestionId,AnswerId,[Index]
	FROM @AnswersOrder

	SELECT @StudentTestId;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateStudentIfNotExsists]    Script Date: 2/5/2019 3:35:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateStudentIfNotExsists]
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
/****** Object:  StoredProcedure [dbo].[DeleteExam]    Script Date: 2/5/2019 3:35:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteExam]
	@ExamId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @deleted bit;
	DELETE FROM Exams WHERE Id = @ExamId AND dbo.IsExamActive(@ExamId) <>0;	
	SELECT CONVERT(bit,@@ROWCOUNT);
    -- Insert statements for procedure here
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetExamStudent]    Script Date: 2/5/2019 3:35:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetExamStudent]
	@ExamId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  Id,[Language],[Name],OpeningText,PassingGrade
	FROM Exams
	WHERE Id = @ExamId;
	
	SELECT qa.Id,qa.IsHorizontal,qa.IsMultipleChoice,qa.Question,qa.TextBelowQuestion
	FROM Questions AS qa
	INNER JOIN ExamsQuestions AS eq ON qa.Id = eq.QuestionId
	WHERE eq.ExamId = @ExamId 
	ORDER BY qa.Id;

	SELECT an.QuestionId
	FROM Answers AS an
	INNER JOIN ExamsQuestions AS eq ON an.QuestionId = eq.QuestionId
	WHERE eq.ExamId = @ExamId
	ORDER BY an.QuestionId;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateExam]    Script Date: 2/5/2019 3:35:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateExam]
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
USE [master]
GO
ALTER DATABASE [examsDb] SET  READ_WRITE 
GO
