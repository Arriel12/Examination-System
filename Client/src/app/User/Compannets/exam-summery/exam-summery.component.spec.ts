import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ExamSummeryComponent } from './exam-summery.component';

describe('ExamSummeryComponent', () => {
  let component: ExamSummeryComponent;
  let fixture: ComponentFixture<ExamSummeryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ExamSummeryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExamSummeryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
