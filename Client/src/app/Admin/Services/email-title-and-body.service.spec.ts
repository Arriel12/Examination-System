import { TestBed } from '@angular/core/testing';

import { EmailTitleAndBodyService } from './email-title-and-body.service';

describe('EmailTitleAndBodyService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: EmailTitleAndBodyService = TestBed.get(EmailTitleAndBodyService);
    expect(service).toBeTruthy();
  });
});
