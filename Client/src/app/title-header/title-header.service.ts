import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class TitleHeaderService {
 
  constructor() { }

  getCurrentUser() :User{
    return {
      id:'1',
      name:'yaron'
    }
  }
}
export interface User{
  id:string;
  name:string;
}
