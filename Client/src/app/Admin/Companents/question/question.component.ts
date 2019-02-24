import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-question',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.css']
})
export class QuestionComponent implements OnInit {
  questionCategory= [
  {id: 1, name: "development"},
  {id: 2, name: "art"},
  {id: 3, name: "qu"},
  ]

  questionType= [
    {id: 1, name: "single answer"},
    {id: 2, name: "multiple answer"},
    ]
  constructor() { }

  ngOnInit() {
  }

}
