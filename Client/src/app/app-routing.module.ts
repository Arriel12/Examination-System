import { QuestionComponent } from './Admin/Companents/question/question.component';
import { AdminLayoutComponent } from './Admin/Companents/admin-layout/admin-layout.component';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { ExamFormComponent } from './Admin/Companents/exam-form/exam-form.component';
import { UserLayoutComponent } from './User/user-layout/user-layout.component';
import { AppComponent } from './app.component';
import { LoginComponent } from './Admin/Companents/login/login.component';
import {AuthGuardService as AuthGuard } from './Admin/Services/auth-guard.service'
import {CategoryGuardService as CateegoryGuard} from './Admin/Services/category-guard.service'


const routes: Routes = [
  //  {
  //    path: '',
  //    component: AppComponent
  //  },
  {
    path: 'user', 
    component: UserLayoutComponent
  },
  {
    path: 'admin/login',
    component: LoginComponent
  },
  {
    path: 'admin', 
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children:[
      {
        path: 'createQuestion',
        canActivate: [AuthGuard,CateegoryGuard],
        component: QuestionComponent
      },
      {
        path: 'exams',
        canActivate: [AuthGuard,CateegoryGuard],
        component: ExamListComponent
      },
      {
        path: 'exams/create',
        canActivate: [AuthGuard,CateegoryGuard],
        component: ExamFormComponent
      },     
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
