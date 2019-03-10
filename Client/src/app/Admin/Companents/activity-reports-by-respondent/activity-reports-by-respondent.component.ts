import { Component, OnInit, Input} from '@angular/core';
import { Student } from '../../Models/Student';
import { ReportsService } from '../../Services/reports.service';
import { StudentReportEntery } from '../../Models/StudentRepotEntery';

@Component({
  selector: 'activity-reports-by-respondent',
  templateUrl: './activity-reports-by-respondent.component.html',
  styleUrls: ['./activity-reports-by-respondent.component.css']
})
export class ActivityReportsByRespondentComponent implements OnInit {

  @Input() student: Student;
  averageGrade: number;
  selectedTestName: string;
  modalElement:StudentReportEntery = new StudentReportEntery();

  elements: StudentReportEntery[] = [];

  headElements = ['Instance', 'Test Id', 'Test Name', 'Grade', 'Handed On'];

  showResultForThisTest(el: StudentReportEntery){
    this.modalElement =el;
    this.selectedTestName = el.Name;
    return this.selectedTestName;
  }

  calculateAverage(){
    let sumOfGrade = 0;

    for (let index = 0; index < this.elements.length; index++) {
      sumOfGrade += this.elements[index].Grade;
    }
    this.averageGrade = sumOfGrade / this.elements.length;
    return this.averageGrade;
  }

  constructor(private reportService: ReportsService) {
   }

  ngOnInit() {
    debugger;
    this.reportService.GetStudentReport(this.student.Email).subscribe(enteries=>{
      this.elements = enteries;
    });
  }

}
