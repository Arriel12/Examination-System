import { Component, OnInit } from '@angular/core';
import { StudentExamService } from '../../Services/student-exam.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-exam-registration',
  templateUrl: './exam-registration.component.html',
  styleUrls: ['./exam-registration.component.css']
})
export class ExamRegistrationComponent implements OnInit {

  constructor(private examService: StudentExamService, private router: Router,
    private activeRoute: ActivatedRoute) {
  }

  ngOnInit() {
  }

  register(f) {
    let examId = this.activeRoute.snapshot.paramMap.get('examId');

    this.examService.StartExam(examId, f, (err) => {
      if (err == '') {
        let url = `/user/${examId}/intro`;
        this.router.navigate([url]);
      }
      else if(err.status==400){
        alert('invalid data insrted');
      }
      else{
        alert("can't find requested exam please make sure the url is correct and try agin later");
      }
    })
  }

}
