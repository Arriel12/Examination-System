import { Injectable } from '@angular/core';
import { AdminDataService } from './admin-data.service';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class ReportsService {

  constructor(private admin: AdminDataService, private http: HttpClient) {
    
   }

   
}
