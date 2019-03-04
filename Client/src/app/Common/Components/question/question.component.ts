import { Component, OnInit, Input } from '@angular/core';
import { StudentQuestion } from '../../Models/StudentQuestion';

@Component({
  selector: 'app-examQuestion',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.css']
})
export class QuestionComponent implements OnInit {
  @Input() question:StudentQuestion
  constructor() { }

  ngOnInit() {
  }

  SelectAnswer(index){
    for(let i=0;i<this.question.answers.length;i++)
      this.question.answers[i].selected = i==index;
  }

}
