import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { StudentExam } from '../Modules/StudentExam';
import { ActivatedRoute, Router } from '@angular/router';
import { ExamIntroComponent } from '../Compannets/exam-intro/exam-intro.component';
import { ExamSummery } from '../Modules/ExamSummery';

@Injectable({
  providedIn: 'root'
})
export class StudentExamService {

  private Exam: StudentExam;
  examSummery: ExamSummery;

  constructor(private http: HttpClient,private activeRoute: ActivatedRoute,
    private router:Router) { 
      //for summery testing only
     // this.Exam = new StudentExam();
      //this.Exam.id ='00053a701e4c903ab8e669823d288bc8';
    }

  StartExam(examId,student,callbeck){

    let url =environment.apiEndpoint+`/exams/${examId}`;
    this.http.post<StudentExam>(url,student).subscribe(data=>{
      this.Exam = data;
      sessionStorage.setItem("StudentExam",JSON.stringify(data));
      callbeck('');
    },err=>callbeck(err));
  }

  AnswerQuestion(questionId,answersIds){
    let url =environment.apiEndpoint+`/exams/${this.Exam.id}/answer`;
    return this.http.post(url,{questionId:questionId,answers:answersIds});
  }

  SubmitExam(callbeck){
    let url =environment.apiEndpoint+`/exams/${this.Exam.id}/submit`;
    this.http.post<ExamSummery>(url,{}).subscribe(data=>{
      this.examSummery = data;
      callbeck('');
    },err=>callbeck(err));
  }

  getExam(){
    if(!this.Exam)
      this.Exam = JSON.parse(sessionStorage.getItem('StudentExam'));
    return this.Exam;
  }
}
