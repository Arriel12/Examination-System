import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnwseredTestComponent } from './anwsered-test.component';

describe('AnwseredTestComponent', () => {
  let component: AnwseredTestComponent;
  let fixture: ComponentFixture<AnwseredTestComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnwseredTestComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnwseredTestComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
