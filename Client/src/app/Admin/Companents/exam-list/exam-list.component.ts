import { Component, OnInit, Input, HostListener, ChangeDetectorRef, AfterViewInit, ViewChild } from '@angular/core';
import { MdbTableService, MdbTablePaginationComponent } from 'angular-bootstrap-md';

import { Category } from '../../Models/category';
import { ExamListEntery } from '../../Models/examListEntery'
import { ExamsDataService } from '../../Services/exams-data.service';
import { AdminDataService } from '../../Services/admin-data.service';
import { Router } from '@angular/router';


@Component({
  selector: 'app-exam-list',
  templateUrl: './exam-list.component.html',
  styleUrls: ['./exam-list.component.css']
})
export class ExamListComponent implements OnInit, AfterViewInit {
  @ViewChild(MdbTablePaginationComponent) mdbTablePagination: MdbTablePaginationComponent;


  headElements: string[] = ['Id', 'Link', 'Name', 'Number of questions',
    'Last Update', ''];

  category: Category;
  elements: ExamListEntery[];
  searchText: string = '';
  previous: string;
  firstItemIndex: number;
  lastItemIndex: number;

  constructor(private examsData: ExamsDataService,
    private admin: AdminDataService,
    private tableService: MdbTableService,
    private cdRef: ChangeDetectorRef,
    private router : Router) {
    this.category = admin.getCategory();
    this.GetExams();
    this.admin.CategoryChanged.subscribe(category => {
      this.GetExams();
      this.category = category;
    })
  }

  private GetExams() {
    this.examsData.GetList().subscribe(data => {
      this.elements = data.map(item => {
        for (const key in item) {
          if (item.hasOwnProperty(key))
            item[key] = item[key].toString();
        }
        return item;
      });
      this.tableService.setDataSource(this.elements);
      this.tableService.searchLocalDataBy("test");
      this.elements = this.tableService.getDataSource();
      this.previous = this.tableService.getDataSource();
    });
  }

  @HostListener('input') oninput() {
    this.searchItems();
  }

  ngOnInit() {


  }

  ngAfterViewInit() {
    this.mdbTablePagination.setMaxVisibleItemsNumberTo(5);
    this.firstItemIndex = this.mdbTablePagination.firstItemIndex;
    this.lastItemIndex = this.mdbTablePagination.lastItemIndex;

    this.mdbTablePagination.calculateFirstItemIndex();
    this.mdbTablePagination.calculateLastItemIndex();
    this.cdRef.detectChanges();
  }

  onNextPageClick(data: any) {
    this.firstItemIndex = data.first;
    this.lastItemIndex = data.last;
  }

  onPreviousPageClick(data: any) {
    this.firstItemIndex = data.first;
    this.lastItemIndex = data.last;
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

  delete(test: ExamListEntery, index) {
    this.examsData.DeleteExam(parseInt(test.Id)).subscribe(d=>{});
    this.tableService.removeRow(index);
  }

  update(test: ExamListEntery, index) {

  }

  create() {
  }
}
