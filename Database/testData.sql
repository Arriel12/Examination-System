
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

INSERT INTO Exams