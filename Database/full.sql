USE [master]
GO
/****** Object:  Database [examsDb]    Script Date: 2/11/2019 10:44:42 AM ******/
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
/****** Object:  User [ExamSql]    Script Date: 2/11/2019 10:44:44 AM ******/
CREATE USER [ExamSql] FOR LOGIN [ExamSql] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ExamAdmin]    Script Date: 2/11/2019 10:44:44 AM ******/
CREATE USER [ExamAdmin] FOR LOGIN [ExamAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [ExecuteSPs]    Script Date: 2/11/2019 10:44:44 AM ******/
CREATE ROLE [ExecuteSPs]
GO
ALTER ROLE [ExecuteSPs] ADD MEMBER [ExamSql]
GO
ALTER ROLE [db_owner] ADD MEMBER [ExamAdmin]
GO
/****** Object:  UserDefinedTableType [dbo].[AnswersOrderList]    Script Date: 2/11/2019 10:44:45 AM ******/
CREATE TYPE [dbo].[AnswersOrderList] AS TABLE(
	[AnswerId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[IDList]    Script Date: 2/11/2019 10:44:45 AM ******/
CREATE TYPE [dbo].[IDList] AS TABLE(
	[ID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[QuestionOrderList]    Script Date: 2/11/2019 10:44:45 AM ******/
CREATE TYPE [dbo].[QuestionOrderList] AS TABLE(
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetAdminOrganization]    Script Date: 2/11/2019 10:44:45 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[IsExamActive]    Script Date: 2/11/2019 10:44:45 AM ******/
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
	@ExamId int
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
/****** Object:  Table [dbo].[Answers]    Script Date: 2/11/2019 10:44:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NOT NULL,
	[IsCorrect] [bit] NOT NULL,
	[Answer] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AnswersOrder]    Script Date: 2/11/2019 10:44:46 AM ******/
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
/****** Object:  Table [dbo].[Categories]    Script Date: 2/11/2019 10:44:46 AM ******/
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
/****** Object:  Table [dbo].[Exams]    Script Date: 2/11/2019 10:44:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exams](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_Exams_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamsQuestions]    Script Date: 2/11/2019 10:44:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamsQuestions](
	[ExamId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
 CONSTRAINT [PK_ExamsQuestions_1] PRIMARY KEY CLUSTERED 
(
	[ExamId] ASC,
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 2/11/2019 10:44:46 AM ******/
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
/****** Object:  Table [dbo].[Questions]    Script Date: 2/11/2019 10:44:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TextBelowQuestion] [nvarchar](2000) NULL,
	[Question] [nvarchar](2000) NOT NULL,
	[IsMultipleChoice] [bit] NOT NULL,
	[IsHorizontal] [bit] NOT NULL,
	[Tags] [nvarchar](2000) NULL,
	[CorrectCount] [tinyint] NOT NULL,
	[OrganizationId] [int] NOT NULL,
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsCategories]    Script Date: 2/11/2019 10:44:47 AM ******/
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
/****** Object:  Table [dbo].[QuestionsOrder]    Script Date: 2/11/2019 10:44:47 AM ******/
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
/****** Object:  Table [dbo].[Students]    Script Date: 2/11/2019 10:44:47 AM ******/
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
/****** Object:  Table [dbo].[StudentTestAnswers]    Script Date: 2/11/2019 10:44:47 AM ******/
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
/****** Object:  Table [dbo].[StudentTests]    Script Date: 2/11/2019 10:44:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [varchar](50) NOT NULL,
	[Grade] [int] NULL,
	[HandedOn] [date] NULL,
	[ExamId] [int] NOT NULL,
 CONSTRAINT [PK_StudentTests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2/11/2019 10:44:47 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_Email_Users] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersOrganizations]    Script Date: 2/11/2019 10:44:48 AM ******/
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
ALTER TABLE [dbo].[Exams]  WITH CHECK ADD  CONSTRAINT [FK_Exams_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[Exams] CHECK CONSTRAINT [FK_Exams_Organizations]
GO
ALTER TABLE [dbo].[ExamsQuestions]  WITH CHECK ADD  CONSTRAINT [FK_ExamsQuestions_Exams1] FOREIGN KEY([ExamId])
REFERENCES [dbo].[Exams] ([Id])
GO
ALTER TABLE [dbo].[ExamsQuestions] CHECK CONSTRAINT [FK_ExamsQuestions_Exams1]
GO
ALTER TABLE [dbo].[ExamsQuestions]  WITH CHECK ADD  CONSTRAINT [FK_ExamsQuestions_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[ExamsQuestions] CHECK CONSTRAINT [FK_ExamsQuestions_Questions]
GO
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD  CONSTRAINT [FK_Questions_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_Organizations]
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
ALTER TABLE [dbo].[StudentTests]  WITH CHECK ADD  CONSTRAINT [FK_StudentTests_Exams1] FOREIGN KEY([ExamId])
REFERENCES [dbo].[Exams] ([Id])
GO
ALTER TABLE [dbo].[StudentTests] CHECK CONSTRAINT [FK_StudentTests_Exams1]
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
/****** Object:  StoredProcedure [dbo].[CreateExam]    Script Date: 2/11/2019 10:44:48 AM ******/
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
	@OrganizationId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	

	Declare @Id int;
	
	-- create exam
	INSERT INTO Exams ([Language],[Name],OpeningText,OrganaizerEmail,PassingGrade,ShowAnswer,CertificateUrl,
	SuccessText,FailText,SuccessMailSubject,SuccessMailBody,FailMailSubject,FailMailBody,OrganizationId)
	VALUES (@Language,@Name,@OpenningText,@OrgenaizerEmail,@PassingGrade,@ShowAnswer,@CertificateUrl,
	@SuccessText,@FailText,@SuccessMailSubject,@SuccessMailBody,@FailMailSubject,@FailMailBody,@OrganizationId);
	SET @Id = SCOPE_IDENTITY();
	-- add questions
	INSERT INTO ExamsQuestions (ExamId,QuestionId)
		SELECT @Id,ID FROM @QuestionsIds;
	-- returns exam id
	SELECT @id AS ExamId;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateStudentExam]    Script Date: 2/11/2019 10:44:48 AM ******/
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
	@ExamId int,
	@StudentEmail varchar(50),
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
	VALUES (@ExamId,@StudentEmail,GETUTCDATE());

	SET @StudentTestId = SCOPE_IDENTITY();
	
	INSERT INTO QuestionsOrder (StudentTestId,QuestionId,QuestionIndex)
	SELECT @StudentTestId,QuestionId,[Index]
	FROM @QuestionsOrder

	INSERT INTO AnswersOrder (StudentTestId,QuestionId,AnswerId,AnswerIndex)
	SELECT @StudentTestId,QuestionId,AnswerId,[Index]
	FROM @AnswersOrder

	SELECT @StudentTestId AS Id;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateStudentIfNotExsists]    Script Date: 2/11/2019 10:44:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteExam]    Script Date: 2/11/2019 10:44:48 AM ******/
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
	@ExamId int
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
/****** Object:  StoredProcedure [dbo].[GetExamAdmin]    Script Date: 2/11/2019 10:44:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetExamAdmin]
	-- Add the parameters for the stored procedure here
	@ExamId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 *
	FROM Exams as ex 
	WHERE Id = @ExamId

	SELECT qs.Id, qs.Question, qs.Tags
	FROM Questions AS qs
	INNER JOIN ExamsQuestions AS eq ON eq.QuestionId = qs.Id
	WHERE eq.ExamId = @ExamId 
END
GO
/****** Object:  StoredProcedure [dbo].[GetExamsList]    Script Date: 2/11/2019 10:44:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetExamsList]
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
/****** Object:  StoredProcedure [dbo].[GetExamStudent]    Script Date: 2/11/2019 10:44:48 AM ******/
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
	@ExamId int
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

	SELECT an.QuestionId,an.Id
	FROM Answers AS an
	INNER JOIN ExamsQuestions AS eq ON an.QuestionId = eq.QuestionId
	WHERE eq.ExamId = @ExamId
	ORDER BY an.QuestionId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetGrade]    Script Date: 2/11/2019 10:44:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetGrade]
	@StudentExamId int,
	@FullData bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @ExamId int, @Grade tinyint, @studentId int;
	
	--Get student test data
	SELECT @ExamId = ExamId, @Grade = Grade, @studentId = StudentId
	FROM StudentTests 
	WHERE Id = @StudentExamId;

	--Calculate grade if missing (and lock the test)
	IF (@Grade = NULL)
	BEGIN
		DECLARE @CourectCount tinyint, @QuestionCount tinyint;
		SELECT @CourectCount = COUNT(qa.Id)
		FROM
			(SELECT sa.QuestionId, SUM(CAST(an.IsCorrect AS INT)) AS CorrectAnswers,
				SUM(CASE WHEN an.IsCorrect = 0 THEN 1 ELSE 0 END) AS WrongAnswers 
			FROM StudentTestAnswers AS sa
			INNER JOIN Answers AS an ON sa.AnswerId = an.Id AND sa.QuestionId = an.QuestionId
			GROUP BY sa.QuestionId)  AS qs
		INNER JOIN Questions AS qa ON qs.QuestionId = qa.Id
		WHERE qs.WrongAnswers = 0 AND qs.CorrectAnswers = qa.CorrectCount;

		SELECT @QuestionCount = COUNT(QuestionId) 
		FROM ExamsQuestions 
		WHERE ExamId = @ExamId;

		SET @Grade = CAST(ROUND(@CourectCount * (100.0/@QuestionCount),0) AS tinyint);

		UPDATE StudentTests 
		SET Grade = @Grade 
		WHERE Id = @StudentExamId;

	END
	--returns requied data
	IF (@FullData =1)
	BEGIN
		SELECT @Grade AS Grade,
			CASE WHEN @Grade<PassingGrade THEN FailText ELSE SuccessText END AS [Text], 
			CASE WHEN @Grade<PassingGrade THEN FailMailSubject ELSE SuccessMailSubject END AS [Subject],
			CASE WHEN @Grade<PassingGrade THEN FailMailBody ELSE SuccessMailBody END AS Body, 
			CASE WHEN @Grade<PassingGrade THEN 0 ELSE 1 END AS Passed,
			CertificateUrl,OrganaizerEmail, ShowAnswer, PassingGrade,[Name],
			st.Email AS StudentEmail, st.FirstName AS StudentFirstName, 
			st.LastName AS StudentLastName, st.Phone AS StudentPhone
		FROM  Exams
		INNER JOIN Students AS st ON st.Email = @studentId  
		WHERE Id = @ExamId;
	END
	ELSE
	BEGIN
		SELECT @Grade AS Grade,	CASE WHEN @Grade<PassingGrade THEN 0 ELSE 1 END AS Passed,
		PassingGrade,[Name]
		FROM  Exams WHERE Id = @ExamId;
	END
    
END
GO
/****** Object:  StoredProcedure [dbo].[SaveStudentAnswers]    Script Date: 2/11/2019 10:44:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveStudentAnswers]
	@StudentExamId int,
	@QuestionId int,
	@AnswerIds AS IdList readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- adds only valid answers
		INSERT INTO StudentTestAnswers (StudentTestId,QuestionId,AnswerId)
		SELECT @StudentExamId,@QuestionId, Id 
		FROM Answers WHERE QuestionId = QuestionId AND Id IN (SELECT ID FROM @AnswerIds);
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateExam]    Script Date: 2/11/2019 10:44:48 AM ******/
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
	@ExamId int,
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
	@QuestionsIds AS dbo.IDList READONLY
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
