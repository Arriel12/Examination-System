import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';
import { AdminDataService } from './admin-data.service';

@Injectable({
  providedIn: 'root'
})
export class CategoryGuardService implements CanActivate {

  constructor(private admin: AdminDataService,private router: Router) { }

  canActivate(): boolean {
    if (!this.admin.getCategory()) {
      let adminUrl ='/admin/';
      this.router.navigate([adminUrl]);
      return false;
    }
    return true;
  }

}
