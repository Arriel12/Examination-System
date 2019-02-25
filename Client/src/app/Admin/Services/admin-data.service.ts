import { Injectable } from '@angular/core';
import { Category } from '../Models/category';
import { Organization } from '../Models/organization';
import { Router, NavigationEnd, NavigationStart } from '@angular/router';
import { environment } from 'src/environments/environment.prod';
import { HttpClient } from '@angular/common/http';
import { JwtHelperService } from '@auth0/angular-jwt';
import { ɵangular_packages_platform_browser_dynamic_platform_browser_dynamic_a } from '@angular/platform-browser-dynamic';

@Injectable({
  providedIn: 'root'
})
export class AdminDataService {

  constructor(private http: HttpClient) {
  }

  token: string = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImlhdCI6MTU1MDM5NTE4My40NDgsImV4cCI6MTU1Mzk5NTE4My40NDgsIm9yZ2FuaXphdGlvbnMiOlsxXSwiYXVkIjoiRXhhbUFkbWluIiwiaXNzIjoiRXhhbUFkbWluIn0.u--ocEYnAEs3-vFEv3tb5H3JoM9wBI5JQDm1h8o6fwg';
  currentCategory: Category = { name: 'a', id: 1 };
  currentOrganization: Organization = { name: 'dev', id: 1 };
  Organizations: Organization[] = [{ name: 'dev', id: 1 }];

  getToken() {
    return localStorage.getItem('token');
  }

  LogIn(username, password, callbeck = null) {
    let creds = {
      "username": username,
      "password": password
    };
    let url = environment.adminApiEndpoint + "/login";
    this.http.post(url, creds, { observe: 'response', responseType: 'text' }).subscribe(resp => {
      let err = null;
      if (resp.status == 200) {
        let token = resp.headers.get("x-token");
        localStorage.setItem('token', token);
        let jwt = new JwtHelperService();
        let pyload = jwt.decodeToken(localStorage.getItem('token'));
        this.Organizations = pyload.organizations;
        if (this.Organizations.length > 0)
          this.currentOrganization = this.Organizations[0];
      }
      else if (resp.status == 401)
        err = 'invalid username or password';
      else
        err = 'unknown error please try agin later.';
      if (callbeck != null)
        callbeck(err);
    });
  }

  isLoggedIn() {
    let jwt = new JwtHelperService();
    let token = this.getToken(); 
    return token!=null && !jwt.isTokenExpired(token);
  }

  logout() {
    localStorage.removeItem('token');
    this.Organizations = null;
    this.currentCategory = null;
    this.currentOrganization = null;
  }

}
