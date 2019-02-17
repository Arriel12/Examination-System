import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ExamListComponent } from './Admin/Companents/exam-list/exam-list.component';

const routes: Routes = [
  {
    path: 'admin/exams/:organizationId/:categoryId',
    component: ExamListComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
