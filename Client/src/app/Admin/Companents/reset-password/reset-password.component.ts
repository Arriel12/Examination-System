import { Component, OnInit } from '@angular/core';
import { AdminDataService } from '../../Services/admin-data.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.css']
})
export class ResetPasswordComponent implements OnInit {

  reset:boolean = false;
  err:string;
  password:string;
  passwordVerification:string;
  constructor(private admin:AdminDataService,private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
  }

  resetPassword()
  {
    let userId = this.activatedRoute.snapshot.paramMap.get('id');
    let userEmail = this.activatedRoute.snapshot.paramMap.get('email');
    this.admin.resetPassword(userId,userEmail,this.password).subscribe(()=>{
      this.reset=true;
    },err=>{
      this.err=err.error.error;
    });
  }

}
