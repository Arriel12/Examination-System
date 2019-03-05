import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportByRespondentNameComponent } from './report-by-respondent-name.component';

describe('ReportByRespondentNameComponent', () => {
  let component: ReportByRespondentNameComponent;
  let fixture: ComponentFixture<ReportByRespondentNameComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReportByRespondentNameComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReportByRespondentNameComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
