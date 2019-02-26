import { Component, OnInit, HostListener, AfterViewInit, ViewChild, ChangeDetectorRef } from '@angular/core';
import { MdbTablePaginationComponent, MdbTableService } from 'angular-bootstrap-md';
import { Category } from '../../Models/category';
import { QuestionService } from '../../Services/question.service';
import { AdminDataService } from '../../Services/admin-data.service';
import { QuestionListEntery } from '../../Models/QuestionListEntery';
import { Router } from '@angular/router';

@Component({
  selector: 'app-question-list',
  templateUrl: './question-list.component.html',
  styleUrls: ['./question-list.component.css']
})
export class QuestionListComponent implements OnInit, AfterViewInit {
  @ViewChild(MdbTablePaginationComponent) mdbTablePagination: MdbTablePaginationComponent;


  headElements: string[] = ['Id', 'Question text and tags', 'Last Update', 'question type',
    '#of tests', ''];

  category: Category;
  elements: QuestionListEntery[];
  searchText: string = '';
  previous: string;
  firstItemIndex: number;
  lastItemIndex: number;

  constructor(private questionsData: QuestionService,
    private admin: AdminDataService,
    private tableService: MdbTableService,
    private cdRef: ChangeDetectorRef,
    private router: Router) {
    this.category = admin.getCategory();
    this.GetQuestions();
    this.admin.CategoryChanged.subscribe(category => {
      this.GetQuestions();
      this.category = category;
    })
  }

  private GetQuestions() {
    this.questionsData.getList().subscribe(data => {
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

  delete(question: QuestionListEntery, index) {
    this.questionsData.delete(parseInt(question.Id)).subscribe(d=>{});
    this.tableService.removeRow(index);
  }

  update(test: QuestionListEntery, index) {

  }

  create() {
    this.router.navigate(['/admin/questions/create']);
  }

  ShowQuestion(questionEntery:QuestionListEntery,index){
    
  }

}
