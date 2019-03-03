import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnwseredQuestionComponent } from './anwsered-question.component';

describe('AnwseredQuestionComponent', () => {
  let component: AnwseredQuestionComponent;
  let fixture: ComponentFixture<AnwseredQuestionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnwseredQuestionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnwseredQuestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
