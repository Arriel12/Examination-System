import { Component, OnInit } from '@angular/core';
import { Category } from '../../Models/category';
import { AdminDataService } from '../../Services/admin-data.service';
import { FormControl, Validators, FormBuilder, FormGroup } from '@angular/forms';
import { Email } from '../../Models/Email';
import { ExamsDataService } from '../../Services/exams-data.service';
import { routerNgProbeToken } from '@angular/router/src/router_module';
import { Router, ActivatedRoute } from '@angular/router';
import { Exam } from '../../Models/Exam';

@Component({
  selector: 'app-exam-form',
  templateUrl: './exam-form.component.html',
  styleUrls: ['./exam-form.component.css']
})
export class ExamFormComponent implements OnInit {

  category: Category;
  testName: string;
  passingGrade: number;
  validationForm: FormGroup;
  showCorrect: boolean;
  massageToSuccess: string;
  massageToFailure: string;
  emailFrom: string;

  passingEmail: Email = new Email();
  failureEmail: Email = new Email();

  selectedIds: number[];

  examId: any;
  exam: Exam;

  constructor(private admin: AdminDataService, public fb: FormBuilder,
    private exams: ExamsDataService, private router: Router,
    private curRoute: ActivatedRoute) {
    this.selectedIds = [];
    this.examId = this.curRoute.snapshot.paramMap.get('id');
    if (this.examId) {
      this.examId = parseInt(this.examId);
      this.exams.GetExam(this.examId).subscribe(ex => {
        ex.questions.forEach(q => {
          this.selectedIds.push(parseInt(q.Id));
        });
        this.passingEmail.messageBody = ex.SuccessMailBody;
        this.passingEmail.messageSubject = ex.SuccessMailSubject;
        this.failureEmail.messageBody = ex.FailMailBody;
        this.failureEmail.messageSubject = ex.FailMailSubject;
        this.exam = ex;
      }, err => {
        //error
        alert('cant load exam to update:' + err.error);
      })
    }
    else {
      this.category = admin.getCategory();
    }
    this.validationForm = fb.group({
      numberFormEx: [null, [Validators.required, Validators.min(0),
      Validators.max(100)]]
    });
  }

  ngOnInit() {
  }

  languages = [
    { id: 1, name: "English" },
    { id: 2, name: "Hebrew" },
  ]


  certificates = [
    { id: 1, name: "Black And White + With Grade" },
    { id: 2, name: "colourful + With Grade" },
    { id: 3, name: "Black And White + Without Grade" },
    { id: 4, name: "colourful + Without Grade" },
  ]


  get numberFormEx() {
    return this.validationForm.get('numberFormEx');
  }
  //get passwordFormEx() { return this.validationForm.get('passwordFormEx'); }

  validateEmail(emailFrom) {
    var regexEmail = /\S+@\S+\.\S+/;
    return regexEmail.test(emailFrom);
  }

  Save(f, f2) {
    debugger;
    if (this.examId)
      this.UpdateExam(f, f2);
    else
      this.AddExam(f, f2);
  }

  private AddExam(f, f2) {
    f.language = f.languages.toLowerCase();
    delete f.languages;
    f.name = f.testName;
    delete f.testName;
    f.openningText = f.Header;
    delete f.Header;
    f.passingGrade = f2.numberFormEx;
    f.showAnswer = f.showCorrect ? true : false;
    delete f.showCorrect;
    if (f.certificates)
      f.certificateUrl = f.certificates;
    delete f.certificates;
    f.successText = f.massageToSuccess;
    delete f.massageToSuccess;
    f.failText = f.massageToFailure;
    delete f.massageToFailure;
    if (f.emailFrom) {
      f.orgenaizerEmail = f.emailFrom;
      f.successMailSubject = this.passingEmail.messageSubject;
      f.successMailBody = this.passingEmail.messageBody;
      f.failMailSubject = this.failureEmail.messageSubject;
      f.failMailBody = this.failureEmail.messageBody;
    }
    delete f.emailFrom;
    f.questionsIds = this.selectedIds
    this.exams.CreateExam(f).subscribe(() => {
      //seccuss
      this.router.navigate(['/admin/exams']);
    }, err => {
      //fail
      if (err.status == 400)
        alert("cant create new exam: invalid request data");
      else
        alert("cant create new exam: " + err.error);
    });
  }

  private UpdateExam(f, f2) {
    if (f.languages)
      f.language = f.languages.toLowerCase();
    delete f.languages;
    if (f.testName)
      f.name = f.testName;
    delete f.testName;
    if (f.Header)
      f.openningText = f.Header;
    delete f.Header;
    if (f2.numberFormEx)
      f.passingGrade = f2.numberFormEx;
    if (f.showCorrect)
      f.showAnswer = f.showCorrect ? true : false;
    delete f.showCorrect;
    if (f.certificates)
      f.certificateUrl = f.certificates;
    delete f.certificates;
    if (f.massageToSuccess)
      f.successText = f.massageToSuccess;
    delete f.massageToSuccess;
    if (f.massageToFailure)
      f.failText = f.massageToFailure;
    delete f.massageToFailure;
    if (f.emailFrom) {
      f.orgenaizerEmail = f.emailFrom;
      f.successMailSubject = this.passingEmail.messageSubject;
      f.successMailBody = this.passingEmail.messageBody;
      f.failMailSubject = this.failureEmail.messageSubject;
      f.failMailBody = this.failureEmail.messageBody;
    }
    delete f.emailFrom;
    f.questionsIds = this.selectedIds
    this.exams.UpdateExam(this.examId,f).subscribe(()=>{
      //seccuss
      this.router.navigate(['/admin/exams']);
    }, err=>{
      //failed
      alert('update failed: '+err.error);
    });
  }

}
