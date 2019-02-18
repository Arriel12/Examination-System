import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { AdminDataService } from './admin-data.service';
import { ExamListEntery } from '../Models/examListEntery';

@Injectable({
  providedIn: 'root'
})
export class ExamsDataService {

  constructor(private http: HttpClient, private admin: AdminDataService) { }

  GetList() {
    let url = environment.apiEndpoint + '/admin/exams/' + this.admin.currentOrganization.id +
     '/' + this.admin.currentCategory.id;
    let options = this.GetOptions();
    return this.http.get<ExamListEntery[]>(url, options);
  }

  GetExam(examId: number) {
    let url = environment.apiEndpoint + '/admin/exams/' + this.admin.currentOrganization.id +
     '/' + this.admin.currentCategory.id + '/' + examId;
    let options = this.GetOptions();
    return this.http.get(url, options);
  }

  UpdateExam(examId: number, data: object) {
    let url = environment.apiEndpoint + '/admin/exams/' + this.admin.currentOrganization.id + 
    '/' + this.admin.currentCategory.id + '/' + examId;
    let options = this.GetOptions();
    return this.http.post(url, data, options);
  }

  CreateExam(data: object) {
    let url = environment.apiEndpoint + '/admin/exams/' + this.admin.currentOrganization.id +
     '/' + this.admin.currentCategory.id +
      '/create';
    let options = this.GetOptions();
    return this.http.post(url, data, options);
  }

  DeleteExam(examId:number) {
    let url = environment.apiEndpoint + '/admin/exams/' + this.admin.currentOrganization.id +
     '/' + this.admin.currentCategory.id + '/' + examId;
    let options = this.GetOptions();
    return this.http.delete(url, options);
  }

  private GetOptions() {
    return {
      headers: new HttpHeaders
        ({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + this.admin.token
        })
    };
  }
}