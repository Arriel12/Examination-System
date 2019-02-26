
INSERT INTO Organizations ([Name])
VALUES ('dev'),('sela');

INSERT INTO Users (Email,PasswordHash,Verified) -- password is 'admin'
VALUES ('shahar240@gmail.com','hG+WxuEIquUq5v5dIuu7gQgTSXos31lWiLRgBAg17Gd5H1KHlw0tSfsQqpH/xcQNcJC12iINZEUl/IMU3/U/YA==',0),
('a@gmail.com','hG+WxuEIquUq5v5dIuu7gQgTSXos31lWiLRgBAg17Gd5H1KHlw0tSfsQqpH/xcQNcJC12iINZEUl/IMU3/U/YA==',1),
('b@gmail.com','hG+WxuEIquUq5v5dIuu7gQgTSXos31lWiLRgBAg17Gd5H1KHlw0tSfsQqpH/xcQNcJC12iINZEUl/IMU3/U/YA==',1),
('c@gmail.com','hG+WxuEIquUq5v5dIuu7gQgTSXos31lWiLRgBAg17Gd5H1KHlw0tSfsQqpH/xcQNcJC12iINZEUl/IMU3/U/YA==',1);

INSERT INTO UsersOrganizations (userId,organizationId)
VALUES (1,1),(2,2),(3,1),(4,1),(4,2);

INSERT INTO Categories ([Name],[OrganizationId])
VALUES ('dev cat 1',1),('dev cat 2',1),('dev cat 3',1),
	('sela cat1',2),('sela cat2',2),('sela cat 3',2);

INSERT INTO Questions (CorrectCount,IsMultipleChoice,Question,Tags,TextBelowQuestion,OrganizationId) 
VALUES (1,0,'click 1','easy,test','below question',1),
		(1,1,'click 1 (multy)','easy,test','below question',1),
		(2,1,'click both 2','easy,test','below question',1),
		(4,1,'click all','easy,test','below question',1);

INSERT INTO QuestionsCategories (CategoryId,QuestionId)
VALUES (1,1),(1,2),(1,3),(1,4);

INSERT INTO Answers (QuestionId,Answer,IsCorrect)
VALUES (1,'1',1),(1,'2',0),(1,'one',0),
	(2,'1',1),(2,'2',0),(2,'one',0),
	(3,'2',1),(3,'1',0),(3,'two',1),
	(4,'1',1),(4,'2',1),(4,'one',1),(4,'false',1);

INSERT INTO Exams (FailMailBody,FailMailSubject,FailText,[Language],[Name],OpeningText,OrganaizerEmail,
OrganizationId,PassingGrade,ShowAnswer,SuccessMailBody,SuccessMailSubject,SuccessText,CategoryId)
VALUES (N'גוף נכשל',N'fail subject',N'נכשלת- you have failed','english',N'testy testy',
N'this is a מבחן',N'mail@gmail.com',1,90,1,N'גוף passing',N'כותרת passing',N'עברת-u passed',1);

DECLARE @examId int;
SET @examId = SCOPE_IDENTITY();
INSERT INTO ExamsQuestions (ExamId,QuestionId)
VALUES (@examId,1),(@examId,2),(@examId,3),(@examId,4)