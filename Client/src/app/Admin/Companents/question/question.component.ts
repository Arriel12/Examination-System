import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-question',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.css']
})
export class QuestionComponent implements OnInit {

selectedTypeId : number;
defualtAnswersId = [1,2,3,4];
answersId = this.defualtAnswersId.length;
isHorizontal: boolean;

constructor() { }

ngOnInit() {
}

  questionCategory= [
  {id: 1, name: "development"},
  {id: 2, name: "art"},
  {id: 3, name: "qu"},
  ]

  questionType= [
    {id: 0, name: "single answer"},
    {id: 1, name: "multiple answers"}
    ]

    answers= [
      {answer: "answer1", isCorrect: 0},
      {answer: "answer2", isCorrect: 0},
      {answer: "answer3", isCorrect: 0},
      {answer: "answer4", isCorrect: 0},
      ]


 addAnswer(){
   if (this.answersId < 10) {
      this.answersId++;
      this.answers.push( {answer: "answer"+ this.answersId, isCorrect: 0});
   }
 }

 deleteAnswer(answersId){
  if (this.answersId > 2) {
    this.answersId--;
    this.answers.splice(this.answersId, 1);
  }
 }

 AddQuestion(f){
   return f.value;
 }

}
