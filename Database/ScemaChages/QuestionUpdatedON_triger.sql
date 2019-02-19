CREATE TRIGGER tgr_questionUpdatedOn
ON Questions
AFTER UPDATE AS
  UPDATE Questions
  SET  UpdatedOn = GETDATE()
  WHERE Id IN (SELECT DISTINCT Id FROM Inserted)