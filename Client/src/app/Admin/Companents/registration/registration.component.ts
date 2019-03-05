import { Component, OnInit } from '@angular/core';
import { AdminDataService } from '../../Services/admin-data.service';

@Component({
  selector: 'app-registration',
  templateUrl: './registration.component.html',
  styleUrls: ['./registration.component.css']
})
export class RegistrationComponent implements OnInit {

  email: string = '';
  password: string = '';
  passwordVerification: string = '';
  registered: boolean = false;
  err: string = '';

  constructor(private admin:AdminDataService) { }

  ngOnInit() {
  }

  register() {
    this.admin.register(this.email,this.password).subscribe(()=>{
      this.registered = true;

    },err=>{
      this.err = err.error.error;  
    })
  }
}
