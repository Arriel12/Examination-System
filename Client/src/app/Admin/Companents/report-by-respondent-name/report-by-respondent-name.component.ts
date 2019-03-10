import { Component, OnInit, HostListener } from '@angular/core';
import { MdbTableService } from 'angular-bootstrap-md';
import { ReportsService } from '../../Services/reports.service';
import { Student } from '../../Models/Student';

@Component({
  selector: 'app-report-by-respondent-name',
  templateUrl: './report-by-respondent-name.component.html',
  styleUrls: ['./report-by-respondent-name.component.scss']
})
export class ReportByRespondentNameComponent implements OnInit {


  elements: Student[] = [];
  headElements = ['#', 'Respondent', 'Email', 'Last Activity', 'Show'];

  Id: any;
  respondentName: string;
  email: string;
  lastActivity: Date;
  showActivity: boolean = false;
  selectedStudent: Student =null;

  searchText: string = '';
  previous: string;



  constructor(private tableService: MdbTableService,reportService: ReportsService) {
    reportService.GetStudents().subscribe(students=>this.SetStudents(students));
   }

  @HostListener('input') oninput() {
    this.searchItems();
  }

  ngOnInit() {
   
  }

  searchItems() {
    const prev = this.tableService.getDataSource();

    if (!this.searchText) {
      this.tableService.setDataSource(this.previous);
      this.elements = this.tableService.getDataSource();
    }

    if (this.searchText) {
      this.elements = this.tableService.searchLocalDataBy(this.searchText);
      this.tableService.setDataSource(prev);
    }

  }

  showActivityExams(respondent: Student) {
    this.Id = respondent.Email
    this.respondentName = respondent.FirstName+" "+respondent.LastName;
    this.email = respondent.Email;
    this.lastActivity = respondent.lastActivity;
    
    this.selectedStudent = respondent;

    this.searchText = '';
    this.showActivity = true;
    
  }


  SetStudents(students){
    // for (let i = 1; i <= 7; i++) {
    //   this.elements.push({ Id: i.toString(), respondent: 'Respondent ' + i, email: 'Last ' + i, lastActivity: 'Last Activity' + i, show: 'show Report ' + i });
    // }
    this.elements = students;
    this.tableService.setDataSource(this.elements);
    this.elements = this.tableService.getDataSource();
    this.previous = this.tableService.getDataSource();
  }
}
