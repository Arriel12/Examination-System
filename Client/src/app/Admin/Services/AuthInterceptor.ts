import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpResponse
} from '@angular/common/http';
import { AdminDataService } from './admin-data.service';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

const adminUrl = environment.adminApiEndpoint;

@Injectable()
export class TokenInterceptor implements HttpInterceptor {
  constructor(public admin: AdminDataService) { }

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    if (request.url.startsWith(adminUrl)) {
      request = request.clone({
        setHeaders: {
          Authorization: `Bearer ${this.admin.getToken()}`
        }
      });
    }
    return next.handle(request);
  }
}