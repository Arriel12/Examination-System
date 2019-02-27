import { Component, OnInit } from '@angular/core';
import { QuestionService } from '../../Services/question.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-question',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.css']
})
export class QuestionComponent implements OnInit {

  selectedTypeId: number;
  isHorizontal: boolean;
  CorrectAnswerRadio: any;
  questionId: any;
  question: string;
  tags: string;
  textBelow: string;
  SelectedQuestionType: number;
  isHorizontalValue: string;

  constructor(private questionsData: QuestionService, private CurRoute: ActivatedRoute,
    private router: Router) {
    this.questionId = this.CurRoute.snapshot.paramMap.get('id');
    if (this.questionId) {
      this.questionsData.get(this.questionId).subscribe(d => {
        this.isHorizontal = d.IsHorizontal;
        this.isHorizontalValue = d.IsHorizontal ? "true" : "false";
        this.answers = d.answers;
        this.question = d.Question;
        this.tags = d.Tags;
        this.textBelow = d.TextBelowQuestion;
        this.SelectedQuestionType = d.IsMultipleChoice ? 1 : 0;
        this.selectedTypeId = d.IsMultipleChoice ? 1 : 0;
        if (!d.IsMultipleChoice) {
          for (let i = 0; i < this.answers.length; i++) {
            if (this.answers[i].IsCorrect) {
              this.CorrectAnswerRadio = this.answers[i];
              break;
            }
          }
        }
      }, err => this.FailHandler(err))
    }
  }

  ngOnInit() {
  }

  questionCategory = [
    { id: 1, name: "development" },
    { id: 2, name: "art" },
    { id: 3, name: "qu" },
  ]

  questionType = [
    { id: 0, name: "single answer" },
    { id: 1, name: "multiple answers" }
  ]

  answers: any[] = [
    { Answer: "", IsCorrect: false },
    { Answer: "", IsCorrect: false },
    { Answer: "", IsCorrect: false },
    { Answer: "", IsCorrect: false },
  ]
  answersId = this.answers.length;


  addAnswer() {
    if (this.answersId < 10) {
      this.answersId++;
      this.answers.push({ Answer: "", IsCorrect: false });
    }
  }

  deleteAnswer(answersId) {
    if (this.answersId > 2) {
      this.answersId--;
      this.answers.splice(this.answersId, 1);
    }
  }

  clearAnswersIsCorrect(skipRadio:boolean = false) {
    this.answers.forEach(answer => {
      answer.IsCorrect = false;
    });
    if(!skipRadio)
      this.CorrectAnswerRadio = null;
  }

  AddQuestion(f) {
    f.isMultipleChoice = f.questionType == "1";
    delete f.questionType;
    f.answers = this.answers;
    if (this.CorrectAnswerRadio != null) {
      this.clearAnswersIsCorrect(true);
      this.CorrectAnswerRadio.IsCorrect = true;
    }
    if (this.questionId) {
      //update
      this.questionsData.update(this.questionId,f).subscribe(
        ()=>this.SuccessHandler(),err=>this.FailHandler(err));
    }
    else {
      //create
      this.questionsData.create(f).subscribe(
        ()=>this.SuccessHandler(), err=>this.FailHandler(err));
    }
  }

  private SuccessHandler()
  {
    this.router.navigate(["/admin/questions"]);
  }

  private FailHandler(error)
  {
    alert(error);
  }

  
}
