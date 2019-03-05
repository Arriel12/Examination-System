import { Component, OnInit } from '@angular/core';
import { AdminDataService } from '../../Services/admin-data.service';

@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.css']
})
export class ForgotPasswordComponent implements OnInit {

  userEmail:string ='';
  sent:boolean = false;
  err: string;
  constructor(private admin:AdminDataService) { }

  ngOnInit() {
  }

  send() {
    this.admin.sendRestPasswordEmail(this.userEmail).subscribe(()=>{
      this.sent=true;
    },err=>{
      this.err=err;
    });

  }

}
