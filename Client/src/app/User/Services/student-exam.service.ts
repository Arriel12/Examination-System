import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { StudentExam } from '../Modules/StudentExam';
import { ActivatedRoute, Router } from '@angular/router';
import { ExamIntroComponent } from '../Compannets/exam-intro/exam-intro.component';

@Injectable({
  providedIn: 'root'
})
export class StudentExamService {

  private Exam: StudentExam;

  constructor(private http: HttpClient,private activeRoute: ActivatedRoute,
    private router:Router) { }

  StartExam(examId,student,callbeck){

    let url =environment.apiEndpoint+`/exams/${examId}`;
    this.http.post<StudentExam>(url,student).subscribe(data=>{
      this.Exam = data;
      sessionStorage.setItem("StudentExam",JSON.stringify(data));
      callbeck('');
    },err=>callbeck(err));
  }

  AnswerQuestion(questionId,answersIds){
    let url =environment.adminApiEndpoint+`/exams/${this.Exam.examId}/answer`;
    return this.http.post(url,{questionId:questionId,answers:answersIds});
  }

  SubmitExam(){
    let url =environment.adminApiEndpoint+`/exams/${this.Exam.examId}/submit`;
    return this.http.post(url,{});
  }

  getExam(){
    if(!this.Exam)
      this.Exam = JSON.parse(sessionStorage.getItem('StudentExam'));
    return this.Exam;
  }
}
