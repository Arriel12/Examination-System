import { TitleHeaderService } from './title-header/title-header.service';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
//import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { from } from 'rxjs';
import { TableModule, MDBBootstrapModule, IconsModule } from 'angular-bootstrap-md';
import { FroalaEditorModule, FroalaViewModule } from 'angular-froala-wysiwyg';
import { JwtModule } from '@auth0/angular-jwt';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { CopyClipboardDirective } from './Admin/Directives/copy-clipboard.directive';
import { ExamFormComponent } from './Admin/Companents/exam-form/exam-form.component';
import { LoginComponent } from './Admin/Companents/login/login.component';
import { RegisterComponent } from './Admin/Companents/register/register.component';
import { QuestionComponent } from './Admin/Companents/question/question.component';
import { QuestionService } from './Admin/Services/question.service';
import { MainComponent } from './Admin/Companents/main/main.component';
import { AdminLayoutComponent } from './Admin/Companents/admin-layout/admin-layout.component';
import { TitleHeaderComponent } from './title-header/title-header.component';
import { UserLayoutComponent } from './User/user-layout/user-layout.component';
import { TokenInterceptor } from './Admin/Services/AuthInterceptor';
import { QuestionListComponent } from './Admin/Companents/question-list/question-list.component';
import { EmailTitleAndBodyComponent } from './Admin/Companents/email-title-and-body/email-title-and-body.component';
import { EmailTitleAndBodyService } from './Admin/Services/email-title-and-body.service';
import { ExamIntroComponent } from './User/Compannets/exam-intro/exam-intro.component';
import { ExamRegistrationComponent } from './User/Compannets/exam-registration/exam-registration.component';
import { ExamSummeryComponent } from './User/Compannets/exam-summery/exam-summery.component';
import { UserTestComponent } from './User/Compannets/user-test/user-test.component';
import { QuestionComponent as studentQuestionCompannet} from './Common/Components/question/question.component';
import { AnwseredQuestionComponent } from './User/Compannets/anwsered-question/anwsered-question.component';
import { AnwseredTestComponent } from './User/Compannets/anwsered-test/anwsered-test.component';
import { RegistrationComponent } from './Admin/Companents/registration/registration.component';
import { ForgotPasswordComponent } from './Admin/Companents/forgot-password/forgot-password.component';
import { ResetPasswordComponent } from './Admin/Companents/reset-password/reset-password.component';
import { GenerateReportByTestComponent } from './Admin/Companents/generate-report-by-test/generate-report-by-test.component';
import { ReportByRespondentNameComponent } from './Admin/Companents/report-by-respondent-name/report-by-respondent-name.component';
import { QuestionSelectorComponent } from './Admin/Companents/question-selector/question-selector.component';
import { ActivityReportsByRespondentComponent } from './Admin/Companents/activity-reports-by-respondent/activity-reports-by-respondent.component';

@NgModule({
  declarations: [
    AppComponent,
    ExamListComponent,
    CopyClipboardDirective,
    ExamFormComponent,
    LoginComponent,
    RegisterComponent,
    QuestionComponent,
    MainComponent,
    AdminLayoutComponent,
    TitleHeaderComponent,
    UserLayoutComponent,
    QuestionListComponent,
    EmailTitleAndBodyComponent,
    ExamIntroComponent,
    ExamRegistrationComponent,
    ExamSummeryComponent,
    UserTestComponent,
    studentQuestionCompannet,
    AnwseredQuestionComponent,
    AnwseredTestComponent,
    RegistrationComponent,
    ForgotPasswordComponent,
    ResetPasswordComponent,
    GenerateReportByTestComponent,
    ReportByRespondentNameComponent,
    QuestionSelectorComponent,
    ActivityReportsByRespondentComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MDBBootstrapModule.forRoot(),
    FroalaEditorModule.forRoot(),
    FroalaViewModule.forRoot(),
    HttpClientModule,
    TableModule,
    //BrowserAnimationsModule,
    FormsModule,
    IconsModule,
    ReactiveFormsModule,
    JwtModule
  ],
  providers: [
    QuestionService,
    TitleHeaderService,
    EmailTitleAndBodyService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: TokenInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
