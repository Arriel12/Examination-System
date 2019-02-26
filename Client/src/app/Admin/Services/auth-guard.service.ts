import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';
import { AdminDataService } from './admin-data.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuardService implements CanActivate {

  constructor(private admin: AdminDataService,private router: Router) { 
  }

  canActivate(): boolean {
    if (!this.admin.isLoggedIn()) {
      let loginUrl ='/admin/login';
      this.router.navigate([loginUrl]);
      return false;
    }
    return true;
  }
}
