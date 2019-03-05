import { QuestionComponent } from './Admin/Companents/question/question.component';
import { AdminLayoutComponent } from './Admin/Companents/admin-layout/admin-layout.component';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { ExamFormComponent } from './Admin/Companents/exam-form/exam-form.component';
import { UserLayoutComponent } from './User/user-layout/user-layout.component';
import { AppComponent } from './app.component';
import { LoginComponent } from './Admin/Companents/login/login.component';
import { AuthGuardService as AuthGuard } from './Admin/Services/auth-guard.service'
import { CategoryGuardService as CateegoryGuard } from './Admin/Services/category-guard.service'
import { QuestionListComponent } from './Admin/Companents/question-list/question-list.component';
import { ExamRegistrationComponent } from './User/Compannets/exam-registration/exam-registration.component';
import { ExamIntroComponent } from './User/Compannets/exam-intro/exam-intro.component';
import { ExamSummeryComponent } from './User/Compannets/exam-summery/exam-summery.component';
import { UserTestComponent } from './User/Compannets/user-test/user-test.component';
import { AnwseredTestComponent } from './User/Compannets/anwsered-test/anwsered-test.component';
import { ForgotPasswordComponent } from './Admin/Companents/forgot-password/forgot-password.component';
import { ResetPasswordComponent } from './Admin/Companents/reset-password/reset-password.component';

const routes: Routes = [
  //  {
  //    path: '',
  //    component: AppComponent
  //  },
  // {
  //   path: 'user',
  //   component: AppComponent,
  //   children:[
  //     {
  //       path: ':examId',
  //       component: ExamRegistrationComponent
  //     },
  //     {
  //       path: ':examId/intro',
  //       component: ExamIntroComponent
  //     },
  //   ]
  // },
  {
    path: 'user/:examId/intro',
    component: ExamIntroComponent
  },
  {
    path: 'user/:examId/start',
    component: UserTestComponent
  },
  {
    path: 'user/:examId/summery',
    component: ExamSummeryComponent
  },
  {
    path: 'user/:examId/answers',
    component: AnwseredTestComponent
  },
  {
    path: 'user/:examId',
    component: ExamRegistrationComponent
  },
  {
    path: 'admin/login',
    component: LoginComponent
  },
  {
    path: 'admin/forgotPassword',
    component: ForgotPasswordComponent
  },
  {
    path: 'admin/resetPassword/:id/:email',
    component: ResetPasswordComponent
  },
  {
    path: 'admin',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'exams',
        canActivate: [AuthGuard, CateegoryGuard],
        component: ExamListComponent
      },
      {
        path: 'exams/create',
        canActivate: [AuthGuard, CateegoryGuard],
        component: ExamFormComponent
      },
      {
        path: 'exams/update/:id',
        canActivate: [AuthGuard, CateegoryGuard],
        component: ExamFormComponent
      },
      {
        path: 'questions',
        canActivate: [AuthGuard, CateegoryGuard],
        component: QuestionListComponent
      },
      {
        path: 'questions/create',
        canActivate: [AuthGuard, CateegoryGuard],
        component: QuestionComponent
      },
      {
        path: 'questions/update/:id',
        canActivate: [AuthGuard, CateegoryGuard],
        component: QuestionComponent
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
