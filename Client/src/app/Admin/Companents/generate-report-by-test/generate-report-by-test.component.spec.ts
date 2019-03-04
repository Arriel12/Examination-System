import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GenerateReportByTestComponent } from './generate-report-by-test.component';

describe('GenerateReportByTestComponent', () => {
  let component: GenerateReportByTestComponent;
  let fixture: ComponentFixture<GenerateReportByTestComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ GenerateReportByTestComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GenerateReportByTestComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
