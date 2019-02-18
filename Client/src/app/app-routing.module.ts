import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';
import { ExamFormComponent } from './Admin/Companents/exam-form/exam-form.component';

const routes: Routes = [
  {
    path: 'admin/exams/:organizationId/:categoryId',
    component: ExamListComponent
  },
  {
    path: 'admin/exams/:organizationId/:categoryId/create',
    component: ExamFormComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
