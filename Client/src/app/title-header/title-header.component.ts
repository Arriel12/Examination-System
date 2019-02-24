import { Component, OnInit } from '@angular/core';
import { TitleHeaderService } from './title-header.service';

@Component({
  selector: 'app-title-header',
  templateUrl: './title-header.component.html',
  styleUrls: ['./title-header.component.css']
})
export class TitleHeaderComponent implements OnInit {

  constructor(private usersService:TitleHeaderService) { }

  ngOnInit() {
    this.usersService.getCurrentUser();
  }

}
