
import { Component, OnInit } from '@angular/core';
import { Category } from '../../Models/category';
import { AdminDataService } from '../../Services/admin-data.service';

@Component({
  selector: 'app-admin-layout',
  templateUrl: './admin-layout.component.html',
  styleUrls: ['./admin-layout.component.css']
})
export class AdminLayoutComponent {

  studyList:Category[];
  selectedTitle ="Choose a field of study";
  isEmptyCategory = true;

  constructor(private admin:AdminDataService) { 
    this.admin.getCategories(categories=>{
      this.studyList=categories;});
  }

  setCategory(category:Category)
  {
    this.admin.setCurrentCategory(category);
    this.selectedTitle = category.Name;
    this.isEmptyCategory = false;
  }

}
