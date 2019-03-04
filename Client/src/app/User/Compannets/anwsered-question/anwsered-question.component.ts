import { Component, OnInit, Input } from '@angular/core';
import { AnsweredQuestion } from 'src/app/Common/Models/AnsweredQuestion';

@Component({
  selector: 'app-anwsered-question',
  templateUrl: './anwsered-question.component.html',
  styleUrls: ['./anwsered-question.component.css']
})
export class AnwseredQuestionComponent implements OnInit {
  @Input() question:AnsweredQuestion;

  constructor() { }

  ngOnInit() {
  }

}
