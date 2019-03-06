import { ExamReportStatistics } from './ExamReportStatistics';
import { ExamReportStudentStatistics } from './ExamReportStudentStatistics';
import { ExamReportQuestionStatistics } from './ExamReportQuestionStatistics';

export class ExamReport
{
    Statitics: ExamReportStatistics;
    StudentsStatistics: ExamReportStudentStatistics [];
    QuestionStatistics: ExamReportQuestionStatistics [];
}