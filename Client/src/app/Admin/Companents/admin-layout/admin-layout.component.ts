
import { Component, OnInit } from '@angular/core';
import { Category } from '../../Models/category';
import { AdminDataService } from '../../Services/admin-data.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-admin-layout',
  templateUrl: './admin-layout.component.html',
  styleUrls: ['./admin-layout.component.css']
})
export class AdminLayoutComponent {

  studyList:Category[];
  selectedTitle ="Choose a field of study";
  isEmptyCategory = true;

  constructor(private admin:AdminDataService,private router:Router) { 
    this.admin.getCategories(categories=>{
      this.studyList=categories;});
  }

  setCategory(category:Category)
  {
    this.admin.setCurrentCategory(category);
    this.selectedTitle = category.Name;
    this.isEmptyCategory = false;
  }

  logout()
  {
    this.admin.logout();
    this.router.navigate(['/admin/login']);
  }

}
