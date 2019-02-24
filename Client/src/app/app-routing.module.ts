import { QuestionComponent } from './Admin/Companents/question/question.component';
import { AdminLayoutComponent } from './Admin/Companents/admin-layout/admin-layout.component';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { ExamFormComponent } from './Admin/Companents/exam-form/exam-form.component';
import { UserLayoutComponent } from './User/user-layout/user-layout.component';
import { AppComponent } from './app.component';

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
    path: 'admin', 
    component: AdminLayoutComponent,
    children:[
      {
        path: 'createQuestion',
        component: QuestionComponent
      },
      {
        path: 'exams/:organizationId/:categoryId',
        component: ExamListComponent
      },
      {
        path: 'exams/:organizationId/:categoryId/create',
        component: ExamFormComponent
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
