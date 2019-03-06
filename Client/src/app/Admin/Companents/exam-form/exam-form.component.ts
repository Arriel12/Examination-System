import { Component, OnInit } from '@angular/core';
import { Category } from '../../Models/category';
import { AdminDataService } from '../../Services/admin-data.service';
import { FormControl, Validators, FormBuilder, FormGroup } from '@angular/forms';
import { Email } from '../../Models/Email';

@Component({
  selector: 'app-exam-form',
  templateUrl: './exam-form.component.html',
  styleUrls: ['./exam-form.component.css']
})
export class ExamFormComponent implements OnInit {

  category: Category;
  testName:string;
  passingGrade: number;
  validationForm: FormGroup;
  showCorrect: boolean;
  massageToSuccess:string;
  massageToFailure:string;
  currentStatus: string;
  emailFrom: string;

  passingEmail: Email = new Email();
  failureEmail: Email = new Email();

  stam:string;


  constructor(private admin: AdminDataService, public fb: FormBuilder) {
    this.category = admin.getCategory();
    this.validationForm = fb.group({
      numberFormEx: [null, [Validators.required, Validators.min(0), 
        Validators.max(100)]]
    });
  }

  ngOnInit() {
  }

  languages = [
    {id : 1, name: "English"},
    {id : 2, name: "Hebrew"},
  ]

  
  certificates = [
    {id : 1, name: "Black And White + With Grade"},
    {id : 2, name: "colourful + With Grade"},
    {id : 3, name: "Black And White + Without Grade"},
    {id : 4, name: "colourful + Without Grade"},
  ]
 

  get numberFormEx() {
     return this.validationForm.get('numberFormEx'); 
    }
  //get passwordFormEx() { return this.validationForm.get('passwordFormEx'); }

  validateEmail(emailFrom){
    var regexEmail = /\S+@\S+\.\S+/;
    return regexEmail.test(emailFrom);
  }

  AddExam(f, f2){
    f.currentStatus = this.stam;
  }
}
