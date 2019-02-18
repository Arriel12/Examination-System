import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
//import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import {TableModule,MDBBootstrapModule,IconsModule} from 'angular-bootstrap-md';
import { FroalaEditorModule, FroalaViewModule } from 'angular-froala-wysiwyg';


import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { CopyClipboardDirective } from './Admin/Directives/copy-clipboard.directive';
import { from } from 'rxjs';
import { ExamFormComponent } from './Admin/Companents/exam-form/exam-form.component';

@NgModule({
  declarations: [
    AppComponent,
    ExamListComponent,
    CopyClipboardDirective,
    ExamFormComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FroalaEditorModule.forRoot(),
    FroalaViewModule.forRoot(),
    HttpClientModule,
    TableModule,
    MDBBootstrapModule.forRoot(),
    //BrowserAnimationsModule,
    FormsModule,
    IconsModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
