import { Component, OnInit, Input, ViewChild, ChangeDetectorRef, HostListener } from '@angular/core';
import { MdbTablePaginationComponent, MdbTableService } from 'angular-bootstrap-md';
import { Category } from '../../Models/category';
import { QuestionListEntery } from '../../Models/QuestionListEntery';
import { QuestionService } from '../../Services/question.service';
import { AdminDataService } from '../../Services/admin-data.service';
import { Router } from '@angular/router';
import { SelectableQuestion } from '../../Models/SelectableQuestion';
import { elementStart } from '@angular/core/src/render3';

@Component({
  selector: 'app-question-selector',
  templateUrl: './question-selector.component.html',
  styleUrls: ['./question-selector.component.css']
})
export class QuestionSelectorComponent implements OnInit {
  @Input() selectedIds: number[];
  @ViewChild(MdbTablePaginationComponent) mdbTablePagination: MdbTablePaginationComponent;

  category: Category;
  elements: SelectableQuestion[];
  searchText: string = '';
  previous: string;
  firstItemIndex: number;
  lastItemIndex: number;

  constructor(private questionsData: QuestionService,
    private admin: AdminDataService,
    private tableService: MdbTableService,
    private cdRef: ChangeDetectorRef,
    private router: Router) {
    this.elements = [];
    this.category = admin.getCategory();

  }

  private GetQuestions() {
    this.questionsData.getList().subscribe(data => {
      this.elements = [];
      data.forEach(el => {
        let question = new SelectableQuestion();
        question.id = el.Id.toString();
        question.isSelected = this.selectedIds.includes(parseInt(el.Id)) ? 'selected' : '';
        question.question = el.Question.toString();
        question.tags = el.Tags.toString();
        this.elements.push(question);
      });

      this.tableService.setDataSource(this.elements);
      this.tableService.searchLocalDataBy("test");
      this.elements = this.tableService.getDataSource();
      this.previous = this.tableService.getDataSource();
    });
  }

  GetCurrentCount() {
    let count = this.elements.filter((x) => x.isSelected).length;
    return count;
  }

  UpdadeSelected(el: SelectableQuestion) {
    let id = parseInt(el.id);
    if (el.isSelected) {
      el.isSelected = '';
      let idx = this.selectedIds.indexOf(id);
      this.selectedIds.splice(idx, 1);
    }
    else {
      el.isSelected = 'selected';
      this.selectedIds.push(id);
    }
  }

  @HostListener('input') oninput() {
    this.searchItems();
  }

  ngOnInit() {
    this.GetQuestions();
    this.admin.CategoryChanged.subscribe(category => {
      this.GetQuestions();
      this.category = category;
    })

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

  ShowQuestion(questionEntery: QuestionListEntery, index) {

  }

}
