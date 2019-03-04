import { Component, OnInit } from '@angular/core';
import { StudentExam } from '../../Modules/StudentExam';
import { StudentExamService } from '../../Services/student-exam.service';

@Component({
  selector: 'app-exam-intro',
  templateUrl: './exam-intro.component.html',
  styleUrls: ['./exam-intro.component.css']
})
export class ExamIntroComponent implements OnInit {

  exam :StudentExam;

  constructor(private examService: StudentExamService) {
    this.exam = this.examService.getExam();
   }

  ngOnInit() {
  }

}
