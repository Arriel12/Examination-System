
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-admin-layout',
  templateUrl: './admin-layout.component.html',
  styleUrls: ['./admin-layout.component.css']
})
export class AdminLayoutComponent {

  studyList = [
    {id:1, name:"development" },
    {id:2, name:"art" },
  ]
  constructor() { }



}
