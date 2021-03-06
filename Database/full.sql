USE [master]
GO
/****** Object:  Database [examsDb]    Script Date: 3/10/2019 11:57:24 AM ******/
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
/****** Object:  User [ExamSql]    Script Date: 3/10/2019 11:57:26 AM ******/
CREATE USER [ExamSql] FOR LOGIN [ExamSql] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ExamAdmin]    Script Date: 3/10/2019 11:57:26 AM ******/
CREATE USER [ExamAdmin] FOR LOGIN [ExamAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [ExecuteSPs]    Script Date: 3/10/2019 11:57:26 AM ******/
CREATE ROLE [ExecuteSPs]
GO
ALTER ROLE [ExecuteSPs] ADD MEMBER [ExamSql]
GO
ALTER ROLE [db_owner] ADD MEMBER [ExamAdmin]
GO
/****** Object:  UserDefinedTableType [dbo].[Answers]    Script Date: 3/10/2019 11:57:27 AM ******/
CREATE TYPE [dbo].[Answers] AS TABLE(
	[Answer] [nvarchar](1000) NULL,
	[IsCorrect] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AnswersOrderList]    Script Date: 3/10/2019 11:57:27 AM ******/
CREATE TYPE [dbo].[AnswersOrderList] AS TABLE(
	[AnswerId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AnswerUpdate]    Script Date: 3/10/2019 11:57:27 AM ******/
CREATE TYPE [dbo].[AnswerUpdate] AS TABLE(
	[Answer] [nvarchar](1000) NULL,
	[IsCorrect] [bit] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[IDList]    Script Date: 3/10/2019 11:57:27 AM ******/
CREATE TYPE [dbo].[IDList] AS TABLE(
	[ID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[QuestionOrderList]    Script Date: 3/10/2019 11:57:27 AM ******/
CREATE TYPE [dbo].[QuestionOrderList] AS TABLE(
	[QuestionId] [int] NOT NULL,
	[Index] [int] NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetAdminOrganization]    Script Date: 3/10/2019 11:57:27 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[IsExamActive]    Script Date: 3/10/2019 11:57:27 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[IsQuestionActive]    Script Date: 3/10/2019 11:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[IsQuestionActive]
(
	@QuestionId int
)
RETURNS bit
AS
BEGIN
	DECLARE @exists bit
	SELECT TOP 1  @exists = Convert(BIT, count(QuestionId)) 
	FROM ExamsQuestions
	WHERE QuestionId = @QuestionId;
	
	RETURN @exists;

END
GO
/****** Object:  Table [dbo].[Answers]    Script Date: 3/10/2019 11:57:27 AM ******/
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
/****** Object:  Table [dbo].[AnswersOrder]    Script Date: 3/10/2019 11:57:28 AM ******/
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
/****** Object:  Table [dbo].[Categories]    Script Date: 3/10/2019 11:57:28 AM ******/
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
/****** Object:  Table [dbo].[Exams]    Script Date: 3/10/2019 11:57:28 AM ******/
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
	[CategoryId] [int] NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Exams_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamsQuestions]    Script Date: 3/10/2019 11:57:28 AM ******/
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
/****** Object:  Table [dbo].[Organizations]    Script Date: 3/10/2019 11:57:28 AM ******/
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
/****** Object:  Table [dbo].[Questions]    Script Date: 3/10/2019 11:57:28 AM ******/
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
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsCategories]    Script Date: 3/10/2019 11:57:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionsCategories](
	[QuestionId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_QuestionsCategories] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsOrder]    Script Date: 3/10/2019 11:57:29 AM ******/
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
/****** Object:  Table [dbo].[Students]    Script Date: 3/10/2019 11:57:29 AM ******/
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
/****** Object:  Table [dbo].[StudentTestAnswers]    Script Date: 3/10/2019 11:57:29 AM ******/
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
/****** Object:  Table [dbo].[StudentTests]    Script Date: 3/10/2019 11:57:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [varchar](50) NOT NULL,
	[Grade] [int] NULL,
	[HandedOn] [datetime] NULL,
	[ExamId] [int] NOT NULL,
 CONSTRAINT [PK_StudentTests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 3/10/2019 11:57:29 AM ******/
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
/****** Object:  Table [dbo].[UsersOrganizations]    Script Date: 3/10/2019 11:57:29 AM ******/
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
ALTER TABLE [dbo].[Exams] ADD  CONSTRAINT [DF_Exams_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[Questions] ADD  CONSTRAINT [DF_Questions_IsHorizontal]  DEFAULT ((0)) FOR [IsHorizontal]
GO
ALTER TABLE [dbo].[Questions] ADD  CONSTRAINT [DF_Questions_CorrectCount]  DEFAULT ((1)) FOR [CorrectCount]
GO
ALTER TABLE [dbo].[Questions] ADD  CONSTRAINT [DF_Questions_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
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
ALTER TABLE [dbo].[Exams]  WITH CHECK ADD  CONSTRAINT [FK_Exams_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Exams] CHECK CONSTRAINT [FK_Exams_Categories]
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
/****** Object:  StoredProcedure [dbo].[CreateExam]    Script Date: 3/10/2019 11:57:30 AM ******/
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
	@OrganizationId int,
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	

	Declare @Id int;
	BEGIN TRANSACTION;
		BEGIN TRY
			IF EXISTS(SELECT 1 FROM Categories WHERE Id = @CategoryId AND OrganizationId = @OrganizationId)
			BEGIN
				-- create exam
				INSERT INTO Exams ([Language],[Name],OpeningText,OrganaizerEmail,PassingGrade,ShowAnswer,CertificateUrl,
				SuccessText,FailText,SuccessMailSubject,SuccessMailBody,FailMailSubject,FailMailBody,OrganizationId,
				CategoryId)
				VALUES (@Language,@Name,@OpenningText,@OrgenaizerEmail,@PassingGrade,@ShowAnswer,@CertificateUrl,
				@SuccessText,@FailText,@SuccessMailSubject,@SuccessMailBody,@FailMailSubject,@FailMailBody,
				@OrganizationId,@CategoryId);
				SET @Id = SCOPE_IDENTITY();
				-- add questions
				INSERT INTO ExamsQuestions (ExamId,QuestionId)
					SELECT @Id,ID FROM @QuestionsIds;
				-- returns exam id
				SELECT @id AS ExamId;
			END
			ELSE
			BEGIN
				SELECT 'Invalid category' AS Error;
			END
			COMMIT TRANSACTION;
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateQuestion]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateQuestion]
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

			SELECT @questionId AS Id;

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH;

END
GO
/****** Object:  StoredProcedure [dbo].[CreateStudentExam]    Script Date: 3/10/2019 11:57:30 AM ******/
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

	BEGIN TRANSACTION;
		BEGIN TRY
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
	    COMMIT TRANSACTION;
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateStudentIfNotExsists]    Script Date: 3/10/2019 11:57:30 AM ******/
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
/****** Object:  StoredProcedure [dbo].[CreateUser]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateUser]
	-- Add the parameters for the stored procedure here
	@Email varchar(50),
	@PassHash varchar(300)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Users (Email,PasswordHash)
	VALUES (@Email,@PassHash);

	SELECT SCOPE_IDENTITY() AS UserId;
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteExam]    Script Date: 3/10/2019 11:57:30 AM ******/
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
	@ExamId int,
	@OrganizationId int,
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @deleted bit;
	DELETE FROM Exams WHERE Id = @ExamId AND dbo.IsExamActive(@ExamId) <> 1 AND 
		CategoryId = @CategoryId AND OrganizationId = @OrganizationId;	
	SELECT CONVERT(bit,@@ROWCOUNT);
    -- Insert statements for procedure here
	
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteQuestion]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteQuestion]
	@QuestionId int,
	@OrganizationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @deleted bit =0,@active bit,@QuestionOrganizationId int;
	BEGIN TRANSACTION;
		BEGIN TRY
			SELECT @active = dbo.IsQuestionActive(@QuestionId), @QuestionOrganizationId = OrganizationId 
			FROM Questions 
			where Id = @QuestionId

			IF(@active<>1 and @QuestionOrganizationId = @OrganizationId)
			Begin
				DELETE FROM QuestionsCategories WHERE QuestionId = @QuestionId ;
				DELETE FROM Answers WHERE QuestionId = @QuestionId;
				DELETE FROM Questions WHERE Id = @QuestionId; 
				SELECT @deleted = CONVERT(bit,@@ROWCOUNT);
			END
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH;	
	SELECT @deleted AS Deleted;
END
GO
/****** Object:  StoredProcedure [dbo].[ExamBasedReport]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExamBasedReport]
@ExamId int,
@StartDate datetime,
@Enddate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- exam statistics
	SELECT  ex.Id,ex.[Name], ex.PassingGrade, COUNT(DISTINCT eq.QuestionId) AS Questions,
	AVG(se.Grade) AS AvarageGrade, COUNT(DISTINCT se.Id) AS Submisions,
	count(distinct (case when  ex.PassingGrade <= se.Grade  then se.Grade end)) AS Passing
	FROM Exams AS ex 
	INNER JOIN ExamsQuestions AS eq ON eq.ExamId = ex.Id
	LEFT JOIN StudentTests AS se ON se.ExamId = ex.Id
	WHERE ex.Id = @ExamId AND (se.Id IS NULL OR se.Grade IS NOT NULL) AND 
		(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
		(@Enddate IS NULL OR se.HandedOn<= @Enddate) 
	GROUP BY ex.Id,ex.[Name], ex.PassingGrade, eq.QuestionId

	--exam median
	SELECT AVG(Grade) AS Median
	FROM
		(SELECT se.Id,se.Grade,
		  ROW_NUMBER() OVER (PARTITION BY se.Id
			 ORDER BY se.Grade ASC, se.Id ASC) AS RowAsc,
		  ROW_NUMBER() OVER (PARTITION BY se.Id
			 ORDER BY se.Grade DESC, se.Id DESC) AS RowDesc
	   FROM StudentTests AS se
	   WHERE se.ExamId = @ExamId AND
		(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
		(@Enddate IS NULL OR se.HandedOn<= @Enddate) 
		 AND (se.Id IS NULL OR se.Grade IS NOT NULL)) AS sm
	WHERE
	   RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1)
	GROUP BY Id
	ORDER BY Id;

	-- student grades
	SELECT CONCAT(st.FirstName,' ',st.LastName) AS FullName,se.HandedOn,
	COUNT(DISTINCT sa.QuestionId) AS SentQuestions ,se.Grade, se.Id
	FROM Exams AS ex
	INNER JOIN StudentTests AS se ON se.ExamId = ex.Id 
	INNER JOIN Students AS st ON st.Email = se.StudentId
	LEFT JOIN StudentTestAnswers AS sa ON sa.StudentTestId = se.Id 
	WHERE ex.Id = @ExamId AND 
		(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
		(@Enddate IS NULL OR se.HandedOn<= @Enddate) AND
		 (se.Id IS NULL OR se.Grade IS NOT NULL)
	GROUP BY st.FirstName,st.LastName,se.HandedOn,se.Grade,se.Id

	--question statistics
		SELECT qu.Id,qu.Question,qu.Tags,
		SUM(CASE WHEN qs.WrongAnswers = 0 AND qs.CorrectAnswers = qu.CorrectCount THEN 1 ELSE 0 END) AS courrectCount,
		COUNT(qs.StudentTestId) AS TotalCount
	FROM Exams AS ex 
	INNER JOIN ExamsQuestions AS eq ON eq.ExamId = ex.Id
	INNER JOIN Questions AS qu ON qu.Id = eq.QuestionId
	 LEFT JOIN (
		SELECT sa.QuestionId, SUM(CAST(an.IsCorrect AS INT)) AS CorrectAnswers,
				SUM(CASE WHEN an.IsCorrect = 0 THEN 1 ELSE 0 END) AS WrongAnswers,
				sa.StudentTestId 
		FROM StudentTests AS se
		INNER JOIN StudentTestAnswers AS sa ON sa.StudentTestId = se.Id
		INNER JOIN Answers AS an ON sa.AnswerId = an.Id AND sa.QuestionId = an.QuestionId
		WHERE se.ExamId = @ExamId AND se.Grade IS NOT NULL AND 
		(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
		(@Enddate IS NULL OR se.HandedOn<= @Enddate)
		GROUP BY sa.QuestionId,sa.StudentTestId)  AS qs	ON qs.QuestionId = qu.Id 
	WHERE ex.Id = @ExamId 
	GROUP BY qu.Id,qu.Question,qu.Tags

END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoriesByOrganization]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategoriesByOrganization]
	@OrganizationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id,[Name],OrganizationId
	FROM Categories
	WHERE OrganizationId = @OrganizationId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetExamAdmin]    Script Date: 3/10/2019 11:57:30 AM ******/
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
/****** Object:  StoredProcedure [dbo].[GetExamsList]    Script Date: 3/10/2019 11:57:30 AM ******/
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
	@OrganizationId int,
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ex.Id,ex.[Name], COUNT(eq.QuestionId) AS Questions,
		(CASE WHEN COUNT(st.Id) = 0 THEN 0 ELSE 1 END) AS IsActive,ex.UpdatedOn
	FROM Exams AS ex
	LEFT JOIN ExamsQuestions AS eq ON eq.ExamId = ex.Id
	LEFT JOIN StudentTests AS st ON st.ExamId = ex.Id
	WHERE ex.OrganizationId = @OrganizationId AND ex.CategoryId = @CategoryId
	GROUP BY ex.Id,ex.[Name],ex.UpdatedOn
END
GO
/****** Object:  StoredProcedure [dbo].[GetExamStudent]    Script Date: 3/10/2019 11:57:30 AM ******/
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

	SELECT an.QuestionId,an.Id,an.Answer
	FROM Answers AS an
	INNER JOIN ExamsQuestions AS eq ON an.QuestionId = eq.QuestionId
	WHERE eq.ExamId = @ExamId
	ORDER BY an.QuestionId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetGrade]    Script Date: 3/10/2019 11:57:30 AM ******/
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
	
	Declare @ExamId int = NULL, @Grade tinyint, @studentEmail varchar(50);
	
	--Get student test data
	SELECT @ExamId = ExamId, @Grade = Grade, @studentEmail = StudentId
	FROM StudentTests 
	WHERE Id = @StudentExamId;
	
	IF(@ExamId IS NULL)
		SELECT 'invalid sutdent exam id' AS Error;
	ELSE
	BEGIN
		--Calculate grade if missing (and lock the test)
		IF (@Grade IS NULL)
		BEGIN
			DECLARE @CourectCount tinyint, @QuestionCount tinyint;
			SELECT @CourectCount = COUNT(qa.Id)
			FROM
				(SELECT sa.QuestionId, SUM(CAST(an.IsCorrect AS INT)) AS CorrectAnswers,
					SUM(CASE WHEN an.IsCorrect = 0 THEN 1 ELSE 0 END) AS WrongAnswers 
				FROM StudentTestAnswers AS sa
				INNER JOIN Answers AS an ON sa.AnswerId = an.Id AND sa.QuestionId = an.QuestionId
				WHERE sa.StudentTestId = @StudentExamId
				GROUP BY sa.QuestionId)  AS qs
			INNER JOIN Questions AS qa ON qs.QuestionId = qa.Id
			WHERE qs.WrongAnswers = 0 AND qs.CorrectAnswers = qa.CorrectCount;

			SELECT @QuestionCount = COUNT(QuestionId) 
			FROM ExamsQuestions 
			WHERE ExamId = @ExamId;

			SET @Grade = CAST(ROUND(@CourectCount * (100.0/@QuestionCount),0) AS tinyint);

			UPDATE StudentTests 
			SET Grade = @Grade, HandedOn = GETUTCDATE()   
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
			INNER JOIN Students AS st ON st.Email = @studentEmail  
			WHERE Id = @ExamId;
		END
		ELSE
		BEGIN
			SELECT @Grade AS Grade,	CASE WHEN @Grade<PassingGrade THEN 0 ELSE 1 END AS Passed,
			PassingGrade,[Name]
			FROM  Exams WHERE Id = @ExamId;
		END
	END
    
END
GO
/****** Object:  StoredProcedure [dbo].[GetQuestion]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetQuestion]
	@OrganizationId int,
	@CategoryId int,
	@QuestionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT qu.Id,qu.IsHorizontal,qu.IsMultipleChoice,qu.OrganizationId,qu.Question,qu.Tags,qu.TextBelowQuestion,qu.UpdatedOn
	FROM Questions AS qu
	WHERE qu.Id = @QuestionId AND qu.Id IN (SELECT QuestionId FROM QuestionsCategories WHERE CategoryId =@CategoryId) 
	AND qu.OrganizationId = @OrganizationId;
	
	IF (@@ROWCOUNT>0) 
		SELECT an.Id,an.QuestionId,an.Answer,an.IsCorrect
		FROM Answers AS an
		WHERE an.QuestionId = @QuestionId;
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetQuestionExamStatistics]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetQuestionExamStatistics]
@ExamId int,
@StartDate datetime,
@Enddate datetime,
@QuestionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT an.Id,an.IsCorrect,an.QuestionId,COUNT(sa.StudentTestId) AS Selected
	FROM Answers AS an
	LEFT JOIN (
		SELECT sta.AnswerId,sta.QuestionId,sta.StudentTestId
		FROM StudentTestAnswers AS sta 
		INNER JOIN StudentTests AS se ON se.ExamId = @ExamId AND 
			(@StartDate IS NULL OR se.HandedOn>= @StartDate) AND
			(@Enddate IS NULL OR se.HandedOn<= @Enddate) AND
			se.Id = sta.StudentTestId) AS sa ON sa.AnswerId=an.Id AND
			 sa.QuestionId = an.Id 
	WHERE an.QuestionId = @QuestionId 
	GROUP BY an.Id,an.IsCorrect,an.QuestionId

END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentAnswers]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetStudentAnswers] 
	@StudentExamId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--questions
    SELECT qu.Question,qu.Id
	FROM Questions AS qu
	INNER JOIN QuestionsOrder AS qo ON qo.QuestionId = qu.Id AND qo.StudentTestId =@StudentExamId
	ORDER BY qo.QuestionIndex
	
	--answers
	SELECT an.Answer,an.IsCorrect,an.QuestionId, (CASE WHEN sta.AnswerId IS NULL THEN 0 ELSE 1 END) AS IsSelected 
	FROM Answers AS an
	INNER JOIN AnswersOrder AS ao ON ao.AnswerId = an.Id AND ao.QuestionId = an.QuestionId AND
		 ao.StudentTestId = @StudentExamId
	INNER JOIN QuestionsOrder AS qo ON qo.QuestionId = ao.QuestionId AND qo.StudentTestId =@StudentExamId
	LEFT JOIN StudentTestAnswers AS sta ON sta.AnswerId = an.Id AND sta.QuestionId = an.QuestionId AND 
		sta.StudentTestId = @StudentExamId 
	ORDER BY qo.QuestionIndex,ao.AnswerIndex 
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudents]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetStudents]
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
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUser]
	@Email varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @userId int, @passHash varchar(300),@verified bit;
	SELECT @userId = UserId, @passHash=PasswordHash, @verified = Verified
	FROM Users 
	WHERE Email = @Email

	SELECT @userId AS UserId, @passHash AS PasswordHash, @verified AS Verified, @Email AS Email;

	SELECT org.[Name],org.Id
	FROM UsersOrganizations AS uo
	INNER JOIN Organizations AS org ON org.Id = uo.organizationId
	WHERE uo.userId = @userId;
END
GO
/****** Object:  StoredProcedure [dbo].[ListQuestions]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ListQuestions]
	@CategoryId int,
	@OrganizationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT qu.Id, qu.Question, qu.Tags,qu.UpdatedOn, qu.IsMultipleChoice, COUNT(eq.ExamId) AS Exams
	FROM Questions AS qu
	INNER JOIN QuestionsCategories AS qc ON qc.QuestionId = qu.Id AND qc.CategoryId = @CategoryId 
	INNER JOIN Categories AS cat ON cat.Id = qc.CategoryId AND cat.OrganizationId = @OrganizationId
	LEFT JOIN ExamsQuestions AS eq ON qu.Id = eq.QuestionId
	GROUP BY qu.Id, qu.Question, qu.Tags,qu.UpdatedOn, qu.IsMultipleChoice;
END
GO
/****** Object:  StoredProcedure [dbo].[ListStudents]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ListStudents]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Email, FirstName, LastName, Phone
	FROM Students
END
GO
/****** Object:  StoredProcedure [dbo].[ResetUserPassword]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ResetUserPassword]
	@UserId int,
	@Email varchar(50),
	@PassHash varchar(300)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Users
	SET PasswordHash = @PassHash
	WHERE UserId = @UserId AND Email = @Email;

	SELECT @@ROWCOUNT AS AffectedRow;

END
GO
/****** Object:  StoredProcedure [dbo].[SaveStudentAnswers]    Script Date: 3/10/2019 11:57:30 AM ******/
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

	DECLARE @submited bit;
	BEGIN TRANSACTION;
		BEGIN TRY
			SELECT @submited=(CASE WHEN Grade IS NULL THEN 0 ELSE 1 END)
			FROM StudentTests 
			WHERE Id = @StudentExamId; 

			IF (@submited =0)
			BEGIN
				--remove old answers
				DELETE FROM StudentTestAnswers 
				WHERE  QuestionId = @QuestionId AND StudentTestId = @StudentExamId;

				-- adds only valid answers
				INSERT INTO StudentTestAnswers (StudentTestId,QuestionId,AnswerId)
				SELECT @StudentExamId,@QuestionId, Id 
				FROM Answers WHERE QuestionId = QuestionId AND Id IN (SELECT ID FROM @AnswerIds);
			END
			ELSE
				SELECT 'Cant change submited test' AS Error;
			COMMIT TRANSACTION;
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowAnswersToStudent]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ShowAnswersToStudent] 
	@studentExamId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1
	FROM StudentTests AS st
	INNER JOIN Exams AS ex ON st.ExamId = ex.Id 
	WHERE st.Id =@studentExamId AND ex.ShowAnswer = 1 AND st.Grade IS NOT NULL) 
		EXEC GetStudentAnswers @studentExamId;
	ELSE
		SELECT 'show answers is disabled for this exam' AS Error;
END
GO
/****** Object:  StoredProcedure [dbo].[StudentBasedRepot]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[StudentBasedRepot]
	@studentEmail varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT se.Id,se.HandedOn,se.Grade,ex.[Name],ex.PassingGrade,se.ExamId
	FROM StudentTests AS se
	INNER JOIN Exams AS ex ON ex.Id = se.ExamId
	WHERE se.StudentId = @studentEmail AND Grade IS NOT NULL;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateExam]    Script Date: 3/10/2019 11:57:30 AM ******/
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
	BEGIN TRANSACTION;
		BEGIN TRY
			UPDATE Exams SET 
				[Language] = COALESCE(@Language,[Language]),
				[Name] =  COALESCE(@Name,[Name]),
				OpeningText = COALESCE(@OpenningText,OpeningText),
				OrganaizerEmail = COALESCE(@OrgenaizerEmail,OrganaizerEmail),
				PassingGrade = COALESCE(@PassingGrade,PassingGrade),
				ShowAnswer = COALESCE(@ShowAnswer,ShowAnswer),
				CertificateUrl = COALESCE(@CertificateUrl,CertificateUrl),
				SuccessText = COALESCE(@SuccessText,SuccessText),
				FailText = COALESCE(@FailText,FailText),
				SuccessMailSubject = COALESCE(@SuccessMailSubject,SuccessMailSubject),
				SuccessMailBody = COALESCE(@SuccessMailBody,SuccessMailBody),
				FailMailSubject = COALESCE(@FailMailSubject,FailMailSubject),
				FailMailBody = COALESCE(@FailMailBody,FailMailBody)
			WHERE Id = @ExamId;
			-- removed removed questions questions
			Delete FROM ExamsQuestions WHERE ExamId = @ExamId AND 
				QuestionId NOT IN (SELECT ID FROM @QuestionsIds);
			-- add missing questions
			INSERT INTO ExamsQuestions (ExamId,QuestionId)
				SELECT @ExamId,ID FROM @QuestionsIds
				WHERE NOT EXISTS( SELECT * FROM ExamsQuestions WHERE ExamId = @ExamId AND  QuestionId = ID);
		    COMMIT TRANSACTION;
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateQuestion]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>R
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateQuestion]
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

			IF(NOT Exists(SELECT TOP 1 1 FROM ExamsQuestions WHERE QuestionId = @QuestionId))
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
				WHERE Id NOT IN (SELECT Id FROM @Answers) AND QuestionId =@QuestionId;

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
/****** Object:  StoredProcedure [dbo].[VerifyUser]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VerifyUser]
	@UserId int,
	@Email varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE Users 
	SET Verified = 1
	WHERE UserId = @UserId AND Email = @Email

	SELECT @@ROWCOUNT AS AffectedRow;
END
GO
/****** Object:  Trigger [dbo].[tgr_examUpdatedOn]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tgr_examUpdatedOn]
ON [dbo].[Exams]
AFTER UPDATE AS
  UPDATE Exams
  SET  UpdatedOn = GETDATE()
  WHERE Id IN (SELECT DISTINCT Id FROM Inserted)
GO
ALTER TABLE [dbo].[Exams] ENABLE TRIGGER [tgr_examUpdatedOn]
GO
/****** Object:  Trigger [dbo].[tgr_questionUpdatedOn]    Script Date: 3/10/2019 11:57:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tgr_questionUpdatedOn]
ON [dbo].[Questions]
AFTER UPDATE AS
  UPDATE Questions
  SET  UpdatedOn = GETDATE()
  WHERE Id IN (SELECT DISTINCT Id FROM Inserted)
GO
ALTER TABLE [dbo].[Questions] ENABLE TRIGGER [tgr_questionUpdatedOn]
GO
USE [master]
GO
ALTER DATABASE [examsDb] SET  READ_WRITE 
GO
