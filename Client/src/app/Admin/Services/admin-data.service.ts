import { Injectable, EventEmitter } from '@angular/core';
import { Category } from '../Models/category';
import { Organization } from '../Models/organization';
import { Router, NavigationEnd, NavigationStart } from '@angular/router';
import { environment } from 'src/environments/environment.prod';
import { HttpClient } from '@angular/common/http';
import { JwtHelperService } from '@auth0/angular-jwt';


@Injectable({
  providedIn: 'root'
})
export class AdminDataService {

  constructor(private http: HttpClient, private router:Router) {
  }

  //token: string = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImlhdCI6MTU1MDM5NTE4My40NDgsImV4cCI6MTU1Mzk5NTE4My40NDgsIm9yZ2FuaXphdGlvbnMiOlsxXSwiYXVkIjoiRXhhbUFkbWluIiwiaXNzIjoiRXhhbUFkbWluIn0.u--ocEYnAEs3-vFEv3tb5H3JoM9wBI5JQDm1h8o6fwg';
  private currentCategory: Category;
  private currentOrganization: Organization;
  private Organizations: Organization[];
  private categoriesOrganizationId: number;
  private categories: Category[];
  public CategoryChanged: EventEmitter<Category> = new EventEmitter();



  getToken() {
    return localStorage.getItem('token');
  }

  register(username: string, password: string) {
    let creds = {
      "username": username,
      "password": password
    };
    let url = environment.adminApiEndpoint + "/register";
    return this.http.post(url, creds);
  }

  LogIn(username: string, password: string, callbeck = null) {
    let creds = {
      "username": username,
      "password": password
    };
    let url = environment.adminApiEndpoint + "/login";
    this.http.post(url, creds, { observe: 'response', responseType: 'text' }).subscribe(resp => {
      let token = resp.headers.get("x-token");
      localStorage.setItem('token', token);
      let jwt = new JwtHelperService();
      let pyload = jwt.decodeToken(localStorage.getItem('token'));
      this.Organizations = pyload.organizations;
      if (this.Organizations.length > 0)
        this.currentOrganization = this.Organizations[0];
      localStorage.setItem('organization', JSON.stringify(this.currentOrganization));
      if (callbeck != null)
        callbeck('');
    }, error => {
      if (error.error instanceof ErrorEvent) {
        // A client-side or network error occurred. Handle it accordingly.
        console.error('An error occurred:', error.error.message);
        callbeck('unknown error please try agin later.');
      } else if (callbeck != null) {
        if (error.status == 401)
          callbeck('invalid username or password');
        else
          callbeck('unknown error please try agin later.');
      }
    });
  }

  isLoggedIn() {
    let jwt = new JwtHelperService();
    let token = this.getToken();
    return token != null && !jwt.isTokenExpired(token);
  }

  logout() {
    localStorage.removeItem('token');
    this.Organizations = null;
    this.currentCategory = null;
    this.currentOrganization = null;
    this.router.navigate(['/admin/login']);
  }

  sendRestPasswordEmail(email: string) {
    let url = environment.adminApiEndpoint + "/sendresetemail";
    return this.http.post(url, { username: email });
  }

  resetPassword(userId,Email,newPassword){
    let url = environment.adminApiEndpoint + `/resetpassword/${userId}/${Email}`;
    return this.http.post(url,{password:newPassword});
  }

  getCategories(callbeck) {
    if (this.categories == null ||
      this.categoriesOrganizationId != this.getOrganization().Id) {
      let url = environment.adminApiEndpoint + "/categories/" + this.getOrganization().Id;
      this.http.get<Category[]>(url, { observe: 'response' }).subscribe(resp => {
        this.categories = resp.body;
        this.categoriesOrganizationId = this.getOrganization().Id;
        callbeck(this.categories);
      });
    }
    else
      callbeck(this.categories);
  }

  setCurrentCategory(category: Category) {
    this.currentCategory = category;
    this.CategoryChanged.emit(this.currentCategory);
  }

  getCategory() {
    return this.currentCategory;
  }

  getOrganization() {
    if (!this.currentOrganization)
      this.currentOrganization = JSON.parse(localStorage.getItem('organization'));
    return this.currentOrganization;
  }

}
