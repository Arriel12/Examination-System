import { Injectable } from '@angular/core';
import { AdminDataService } from './admin-data.service';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Student } from '../Models/Student';
import { StudentReportEntery } from '../Models/StudentRepotEntery';
import { AnsweredQuestion } from 'src/app/Common/Models/AnsweredQuestion';
import { ExamReport } from '../Models/ExamReport';
import { QuestionDetailsReportEntery } from '../Models/QuestionDetailsReportEntery';

@Injectable({
  providedIn: 'root'
})
export class ReportsService {

  constructor(private admin: AdminDataService, private http: HttpClient) {

  }

  GetStudents() {
    let url = environment.adminApiEndpoint + `/reports/Student/${this.admin.getOrganization().Id}`;
    return this.http.get<Student[]>(url);
  }

  GetStudentReport(studentEmail) {
    let url = environment.adminApiEndpoint + `/reports/Student`;
    return this.http.post<StudentReportEntery[]>(url, { studentEmail: studentEmail });
  }

  GetStudentAnswers(studentExamId) {
    let url = environment.adminApiEndpoint + `/reports/StudentAnswers`;
    return this.http.post<AnsweredQuestion[]>(url, { studentExamId: studentExamId });
  }

  GetExamReport(examId,startDate,endDate) {
    let url = environment.adminApiEndpoint + `/reports/exam`;
    let data ={
      examId:examId,
      startDate: startDate ? startDate : null,
      endDate: endDate ? endDate : null
    }
    return this.http.post<ExamReport>(url, data);
  }

  GetQuestionDetails(examId,startDate,endDate,questionId) {
    let url = environment.adminApiEndpoint + `/reports/QuestionStatistics`;
    let data ={
      examId:examId,
      startDate: startDate ? startDate : null,
      endDate: endDate ? endDate : null,
      questionId : questionId
    }
    return this.http.post<QuestionDetailsReportEntery[]>(url, data);
  }
}
