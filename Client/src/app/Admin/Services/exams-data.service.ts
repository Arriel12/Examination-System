import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { AdminDataService } from './admin-data.service';
import { ExamListEntery } from '../Models/examListEntery';
import { Exam } from '../Models/Exam';

@Injectable({
  providedIn: 'root'
})
export class ExamsDataService {

  constructor(private http: HttpClient, private admin: AdminDataService) { }

  GetList() {
    let url = environment.adminApiEndpoint + '/exams/' + this.admin.getOrganization().Id +
     '/' + this.admin.getCategory().Id;
    let options = this.GetOptions();
    return this.http.get<ExamListEntery[]>(url, options);
  }

  GetExam(examId: number) {
    let url = environment.adminApiEndpoint + '/exams/' + this.admin.getOrganization().Id +
     '/' + this.admin.getCategory().Id + '/' + examId;
    let options = this.GetOptions();
    return this.http.get<Exam>(url, options);
  }

  UpdateExam(examId: number, data: object) {
    let url = environment.adminApiEndpoint + '/exams/' + this.admin.getOrganization().Id + 
    '/' + this.admin.getCategory().Id + '/' + examId;
    let options = this.GetOptions();
    return this.http.post(url, data, options);
  }

  CreateExam(data: object) {
    let url = environment.adminApiEndpoint + '/exams/' + this.admin.getOrganization().Id +
     '/' + this.admin.getCategory().Id +
      '/create';
    let options = this.GetOptions();
    return this.http.post(url, data, options);
  }

  DeleteExam(examId:number) {
    let url = environment.adminApiEndpoint + '/exams/' + this.admin.getOrganization().Id +
     '/' + this.admin.getCategory().Id + '/' + examId;
    let options = this.GetOptions();
    return this.http.delete(url, options);
  }

  private GetOptions() {
    return {
      headers: new HttpHeaders
        ({
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer ' + this.admin.token
        })
    };
  }
}
