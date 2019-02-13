import { Component, OnInit, Input } from '@angular/core';
import { MdbTableService } from 'angular-bootstrap-md';

import { Category } from '../../Models/category';
import {ExamListEntery} from '../../Models/examListEntery'


@Component({
  selector: 'app-exam-list',
  templateUrl: './exam-list.component.html',
  styleUrls: ['./exam-list.component.css']
})
export class ExamListComponent implements OnInit {
  
  @Input() category: Category;
  
  constructor() {
   }

  //displayedColumns: string[] = ['Id', 'Link', 'Name', 'Number of questions',
  //'Last Update',''];
  displayedColumns: string[] = ['Id', 'url', 'Name', 'Questions',
  'updatedOn','isActive'];

  

  ngOnInit() {
  }

}
