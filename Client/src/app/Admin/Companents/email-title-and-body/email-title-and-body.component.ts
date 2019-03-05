import { Component, OnInit, Input } from '@angular/core';
import { Email } from '../../Models/Email';

@Component({
  selector: 'email-title-and-body',
  templateUrl: './email-title-and-body.component.html',
  styleUrls: ['./email-title-and-body.component.css']
})
export class EmailTitleAndBodyComponent implements OnInit {

  @Input() email: Email;

  constructor() { }

  ngOnInit() {
  }

}
