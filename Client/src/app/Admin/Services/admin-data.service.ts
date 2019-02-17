import { Injectable } from '@angular/core';
import { Category } from '../Models/category';
import { Organization } from '../Models/organization';
import { Router, NavigationEnd, NavigationStart } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class AdminDataService {

  constructor() { 
  }

  token:string ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImlhdCI6MTU1MDM5NTE4My40NDgsImV4cCI6MTU1Mzk5NTE4My40NDgsIm9yZ2FuaXphdGlvbnMiOlsxXSwiYXVkIjoiRXhhbUFkbWluIiwiaXNzIjoiRXhhbUFkbWluIn0.u--ocEYnAEs3-vFEv3tb5H3JoM9wBI5JQDm1h8o6fwg';
  currentCategory:Category ={name:'a',id:1};
  currentOrganization:Organization={name:'dev',id:1};
  Organizations:Organization[]=[{name:'dev',id:1}];
  
}
