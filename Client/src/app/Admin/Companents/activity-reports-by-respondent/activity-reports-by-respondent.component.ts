import { Component, OnInit, Input} from '@angular/core';

@Component({
  selector: 'activity-reports-by-respondent',
  templateUrl: './activity-reports-by-respondent.component.html',
  styleUrls: ['./activity-reports-by-respondent.component.css']
})
export class ActivityReportsByRespondentComponent implements OnInit {

  @Input() Id: any;
  @Input() respondentName: string;
  @Input() email: string;
  @Input() lastActivity: any;
  averageGrade: number;
  selectedTestName: string;
  modalElement:any = {instanse: '', id: '', testName: '', grade:'',  handedOn: ""};

  elements: any = [
    {instanse: 1, id: '100', testName: 'HTML', grade: 92,  handedOn: "01/10/18"},
    {instanse: 2, id: '101', testName: 'JS', grade: 88,  handedOn: "01/11/18"},
    {instanse: 3, id: '102', testName: 'CSS', grade: 75,  handedOn: "01/12/18"},
  ];

  headElements = ['Instance', 'Test Id', 'Test Name', 'Grade', 'Handed On'];

  showResultForThisTest(el){
    this.modalElement =el;
    this.selectedTestName = el.testName;
    return this.selectedTestName;
  }

  calculateAverage(){
    let sumOfGrade = 0;

    for (let index = 0; index < this.elements.length; index++) {
      sumOfGrade += this.elements[index].grade;
    }
    this.averageGrade = sumOfGrade / this.elements.length;
    return this.averageGrade;
  }

  constructor() { }

  ngOnInit() {
  }

}
