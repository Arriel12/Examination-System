import { Component, OnInit } from '@angular/core';
//import { IMyOptions } from 'ng-uikit-pro-standard';

@Component({
  selector: 'app-generate-report-by-test',
  templateUrl: './generate-report-by-test.component.html',
  styleUrls: ['./generate-report-by-test.component.css']
})
export class GenerateReportByTestComponent implements OnInit {

  anyDate: boolean;
  dateRangeFrom: Date;
  dateRangeTo: Date;

  selectTest = [
    {id : 1, name: "Dom in javaScript"},
    {id : 2, name: "Type Script"},
    {id : 3, name: "Angular"},
    {id : 4, name: "Node JS"},
  ]
  studyField = [{
    name: "Development"
  },
  {
    name: "Art"
  },
  {
    name: "QA"
  },]

  constructor() { }

  ngOnInit() {
  }

}
