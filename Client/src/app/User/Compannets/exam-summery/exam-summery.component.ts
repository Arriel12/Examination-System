import { Component, OnInit } from '@angular/core';
import { StudentExamService } from 'src/app/User/Services/student-exam.service';
import { ExamSummery } from 'src/app/User/Modules/ExamSummery';

@Component({
  selector: 'app-exam-summery',
  templateUrl: './exam-summery.component.html',
  styleUrls: ['./exam-summery.component.css']
})
export class ExamSummeryComponent implements OnInit {

  summery: ExamSummery;
  examName: string;

  constructor(private examService: StudentExamService) {
    //for debug
    // this.examService.SubmitExam(e=>{
    //   this.summery = this.examService.examSummery;
    //   this.summery.showAnswers=true;});
    this.summery = this.examService.examSummery;
    this.examName = this.examService.getExam().name;
  }

  ngOnInit() {
  }
 
}
