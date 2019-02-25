import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { AdminDataService } from './admin-data.service';

@Injectable({
  providedIn: 'root'
})
export class QuestionService {

  constructor(private admin: AdminDataService, private http: HttpClient) {

  }

  create(question) {
    let url = environment.adminApiEndpoint+`/questions/${this.admin.getOrganization().Id}/${this.admin.getCategory().Id}`;
    return this.http.post(url,question);
  }

  get(questionId) {
    let url = environment.adminApiEndpoint+`/questions/${this.admin.getOrganization().Id}/${this.admin.getCategory().Id}/${questionId}`;
    return this.http.get(url);
  }

  getList() {
    let url = environment.adminApiEndpoint+`/questions/${this.admin.getOrganization().Id}/${this.admin.getCategory().Id}`;
    return this.http.get(url);
  }

  update(question) {
    let url = environment.adminApiEndpoint+`/questions/${this.admin.getOrganization().Id}/${this.admin.getCategory().Id}`;
    return this.http.post(url,question);
  }

}
