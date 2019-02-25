import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AdminDataService } from '../../Services/admin-data.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  @ViewChild("darkFormEmailEx") usernameInput: ElementRef;
  @ViewChild("darkFormPasswordEx") passwordInput: ElementRef;
  LoginComponent: FormGroup;
  invalidLogin: boolean;
  loginError: string;

  constructor(public formBuilder: FormBuilder,
    private router: Router, private admin: AdminDataService) {
      if(this.admin.isLoggedIn())
        this.router.navigate(['/admin']);
    this.LoginComponent = formBuilder.group({
      darkFormEmailEx: ['', [Validators.required, Validators.email]],
      darkFormPasswordEx: ['', Validators.required],
    });
  }
  ngOnInit() {
  }

  signIn() {
    this.invalidLogin = false;
    this.loginError = '';
    let username = this.usernameInput.nativeElement.value;
    let password = this.passwordInput.nativeElement.value;
    this.admin.LogIn(username, password, err => {
      if (err && err != '') {
        this.invalidLogin = true;
        this.loginError = err;
      }
      else {
        this.router.navigate(['/admin']);
      }
    })
  }
}
