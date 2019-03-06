import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EmailTitleAndBodyComponent } from './email-title-and-body.component';

describe('EmailTitleAndBodyComponent', () => {
  let component: EmailTitleAndBodyComponent;
  let fixture: ComponentFixture<EmailTitleAndBodyComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EmailTitleAndBodyComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EmailTitleAndBodyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
