import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ExamIntroComponent } from './exam-intro.component';

describe('ExamIntroComponent', () => {
  let component: ExamIntroComponent;
  let fixture: ComponentFixture<ExamIntroComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ExamIntroComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExamIntroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
