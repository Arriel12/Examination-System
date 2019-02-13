import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ExamsDataService {

  constructor(private http: HttpClient) { }

  GetList(organizationid: number, categoryId: number, token: string) {
    let url = environment.apiEndpoint + '/admin/' + organizationid + '/' + categoryId;
    let options = this.GetOptions(token);
    return this.http.get(url, options);
  }

  GetExam(organizationid: number, categoryId: number, token: string, examId: number) {
    let url = environment.apiEndpoint + '/admin/' + organizationid + '/' + categoryId +
      '/' + examId;
    let options = this.GetOptions(token);
    return this.http.get(url, options);
  }

  UpdateExam(organizationid: number, categoryId: number, token: string, examId: number, data: object) {
    let url = environment.apiEndpoint + '/admin/' + organizationid + '/' + categoryId +
      '/' + examId;
    let options = this.GetOptions(token);
    return this.http.post(url, data, options);
  }

  CreateExam(organizationid: number, categoryId: number, token: string, data: object) {
    let url = environment.apiEndpoint + '/admin/' + organizationid + '/' + categoryId +
      '/create';
    let options = this.GetOptions(token);
    return this.http.post(url, data, options);
  }

  CreateDelete(organizationid: number, categoryId: number, token: string, data: object) {
    let url = environment.apiEndpoint + '/admin/' + organizationid + '/' + categoryId +
      '/create';
    let options = this.GetOptions(token);
    return this.http.delete(url, options);
  }

  private GetOptions(token: string) {
    return {
      headers: new HttpHeaders
        ({
          'Content-Type': 'application/json',
          'Authorization': 'bearer ' + token
        })
    };
  }
}
