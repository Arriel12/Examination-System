USE [examsDb]
/****** Object:  Table [dbo].[Answers]    Script Date: 2/4/2019 10:08:30 AM ******/
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
/****** Object:  Table [dbo].[Categories]    Script Date: 2/4/2019 10:08:31 AM ******/
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
/****** Object:  Table [dbo].[Exams]    Script Date: 2/4/2019 10:08:31 AM ******/
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
	[PassingGrade] [int] NOT NULL,
	[ShowAnswer] [bit] NOT NULL,
	[CertificateUrl] [varchar](255) NULL,
	[SuccessText] [nvarchar](2000) NULL,
	[FailText] [nvarchar](2000) NULL,
	[SuccessMailSubject] [nvarchar](255) NULL,
	[SuccessMailBody] [nvarchar](2000) NULL,
	[FailMailSubject] [nvarchar](255) NULL,
	[FailMailBody] [nvarchar](2000) NULL,
 CONSTRAINT [PK_Exams] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamsQuestions]    Script Date: 2/4/2019 10:08:31 AM ******/
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
/****** Object:  Table [dbo].[Organizations]    Script Date: 2/4/2019 10:08:32 AM ******/
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
/****** Object:  Table [dbo].[Questions]    Script Date: 2/4/2019 10:08:32 AM ******/
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
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsCategories]    Script Date: 2/4/2019 10:08:32 AM ******/
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
/****** Object:  Table [dbo].[Student]    Script Date: 2/4/2019 10:08:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
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
/****** Object:  Table [dbo].[StudentTestAnswers]    Script Date: 2/4/2019 10:08:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTestAnswers](
	[StudentTestId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[AnswerId] [int] NOT NULL,
	[QuestionIndex] [int] NOT NULL,
 CONSTRAINT [PK_StudentTestAnswers] PRIMARY KEY CLUSTERED 
(
	[StudentTestId] ASC,
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentTests]    Script Date: 2/4/2019 10:08:32 AM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 2/4/2019 10:08:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Email] [varchar](50) NOT NULL,
	[OrganizationId] [int] NULL,
	[PasswordHash] [varchar](300) NOT NULL,
	[Verified] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exams] ADD  CONSTRAINT [DF_Exams_ShowAnswer]  DEFAULT ((0)) FOR [ShowAnswer]
GO
ALTER TABLE [dbo].[Questions] ADD  CONSTRAINT [DF_Questions_IsHorizontal]  DEFAULT ((0)) FOR [IsHorizontal]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Verified]  DEFAULT ((0)) FOR [Verified]
GO
ALTER TABLE [dbo].[Answers]  WITH CHECK ADD  CONSTRAINT [FK_Answers_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[Answers] CHECK CONSTRAINT [FK_Answers_Questions]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [FK_Categories_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [FK_Categories_Organizations]
GO
ALTER TABLE [dbo].[Exams]  WITH CHECK ADD  CONSTRAINT [FK_Exams_ExamsQuestions] FOREIGN KEY([Id])
REFERENCES [dbo].[ExamsQuestions] ([ExamId])
GO
ALTER TABLE [dbo].[Exams] CHECK CONSTRAINT [FK_Exams_ExamsQuestions]
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
REFERENCES [dbo].[Student] ([Email])
GO
ALTER TABLE [dbo].[StudentTests] CHECK CONSTRAINT [FK_StudentTests_Student]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([Id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Organizations]
GO
USE [master]
GO
ALTER DATABASE [examsDb] SET  READ_WRITE 
GO
