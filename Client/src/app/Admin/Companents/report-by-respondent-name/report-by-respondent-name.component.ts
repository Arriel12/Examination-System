import { Component, OnInit, HostListener } from '@angular/core';
import { MdbTableService } from 'angular-bootstrap-md';

@Component({
  selector: 'app-report-by-respondent-name',
  templateUrl: './report-by-respondent-name.component.html',
  styleUrls: ['./report-by-respondent-name.component.scss']
})
export class ReportByRespondentNameComponent implements OnInit {


  elements: any = [];
  headElements = ['ID', 'Respondent', 'Email', 'Last Activity', 'Show'];

  Id: any;
  respondentName: string;
  email: string;
  lastActivity: Date;
  showActivity: boolean = false;

  searchText: string = '';
  previous: string;



  constructor(private tableService: MdbTableService) { }

  @HostListener('input') oninput() {
    this.searchItems();
  }

  ngOnInit() {
    for (let i = 1; i <= 7; i++) {
      this.elements.push({ Id: i.toString(), respondent: 'Respondent ' + i, email: 'Last ' + i, lastActivity: 'Last Activity' + i, show: 'show Report ' + i });
    }

    this.tableService.setDataSource(this.elements);
    this.elements = this.tableService.getDataSource();
    this.previous = this.tableService.getDataSource();
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

  showActivityExams(respondent) {
    this.Id = respondent.Id;
    this.respondentName = respondent.respondent;
    this.email = respondent.email;
    this.lastActivity = respondent.lastActivity;
    
    this.searchText = '';
    this.showActivity = true;
    
  }

}
