import { Component, OnInit } from '@angular/core';
import { AnsweredQuestion } from 'src/app/Common/Models/AnsweredQuestion';
import { StudentExamService } from '../../Services/student-exam.service';

@Component({
  selector: 'app-anwsered-test',
  templateUrl: './anwsered-test.component.html',
  styleUrls: ['./anwsered-test.component.css']
})
export class AnwseredTestComponent implements OnInit {

  questions:AnsweredQuestion[];
  questionIndex = 0;

  constructor(private examService: StudentExamService) {
    examService.GetAnswers().subscribe(data=>{
      this.questions = data;
    },err=>{
      alert('invalid request');
    });
    //this.questions = examService.getExam().questions;
   }

  ngOnInit() {
  }

  nextQuestion(){
    if(this.questionIndex<this.questions.length-1)
      this.questionIndex++;
  }

  previusQuestion(){
    if(this.questionIndex>0)
      this.questionIndex--;
  }

  selectQuestion(index)
  {
    if(index>=0 && index<this.questions.length)
      this.questionIndex = index;
  }

  

}
