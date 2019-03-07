import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ActivityReportsByRespondentComponent } from './activity-reports-by-respondent.component';

describe('ActivityReportsByRespondentComponent', () => {
  let component: ActivityReportsByRespondentComponent;
  let fixture: ComponentFixture<ActivityReportsByRespondentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivityReportsByRespondentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ActivityReportsByRespondentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
