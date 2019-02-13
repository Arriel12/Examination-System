import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


import {TableModule} from 'angular-bootstrap-md';
import { FroalaEditorModule, FroalaViewModule } from 'angular-froala-wysiwyg';


import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { from } from 'rxjs';

@NgModule({
  declarations: [
    AppComponent,
    ExamListComponent,
    TableModule
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FroalaEditorModule.forRoot(),
    FroalaViewModule.forRoot(),
    HttpClientModule,
    BrowserAnimationsModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
