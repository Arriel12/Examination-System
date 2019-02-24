import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { LoginService } from '../../Services/login.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
   LoginComponent: FormGroup;
   invalidLogin: boolean; 


   constructor(public formBuilder: FormBuilder, private service: LoginService,
      private router: Router)
      {
        
     this.LoginComponent = formBuilder.group({
       darkFormEmailEx: ['', [Validators.required, Validators.email]],
       darkFormPasswordEx: ['', Validators.required], 
     });
   }
   ngOnInit() {
  }

   signIn(credentials) {
     this.service.login(credentials)
       .subscribe(result => { 
         if (result)
           this.router.navigate(['/']);
         else  
           this.invalidLogin = true; 
       });
   }
}
