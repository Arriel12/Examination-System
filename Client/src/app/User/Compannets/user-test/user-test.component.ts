import { Component, OnInit } from '@angular/core';
import { StudentExamService } from '../../Services/student-exam.service';
import { StudentQuestion } from 'src/app/Common/Models/StudentQuestion';
import { Router } from '@angular/router';

@Component({
  selector: 'app-user-test',
  templateUrl: './user-test.component.html',
  styleUrls: ['./user-test.component.css']
})
export class UserTestComponent implements OnInit {

  private questions:StudentQuestion[];
  private questionIndex = 0;

  constructor(private examService: StudentExamService,private router:Router) {
    this.questions = examService.getExam().questions;
   }

  ngOnInit() {
  }

  nextQuestion(){
    this.SaveAnswer();
    if(this.questionIndex<this.questions.length-1)
      this.questionIndex++;
  }

  previusQuestion(){
    this.SaveAnswer();
    if(this.questionIndex>0)
      this.questionIndex--;
  }

  submit()
  {
    this.SaveAnswer();
    if(confirm("Are you sure?")) {
      this.examService.SubmitExam(err=>{
        if(err==''){
          let examId = this.examService.getExam().id;
          this.router.navigate([`/user/${examId}/summery`]);
        }
        else
          alert(`submition failed,please try agian. \r\n error:${err}`); 
      })
    }
  }

  selectQuestion(index)
  {
    this.SaveAnswer();
    if(index>=0 && index<this.questions.length)
      this.questionIndex = index;
  }

  private SaveAnswer()
  {
    this.questions[this.questionIndex].isAnswered = false;
    let answers: number[] = [];
    for(let i=0;i<this.questions[this.questionIndex].answers.length;i++)
    {
      if(this.questions[this.questionIndex].answers[i].selected){
        this.questions[this.questionIndex].isAnswered = true;
        answers.push(this.questions[this.questionIndex].answers[i].id);
      }
    }
    let idx = this.questionIndex;
    let questionId = this.questions[this.questionIndex].id;
    this.examService.AnswerQuestion(questionId,answers).subscribe(data=>{},err=>{
      alert(`question submition failed for question:${idx+1}`);
      this.questions[idx].isAnswered = false;
    })
  }

}
