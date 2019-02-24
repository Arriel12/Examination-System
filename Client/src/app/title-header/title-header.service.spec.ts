import { TestBed } from '@angular/core/testing';

import { TitleHeaderService } from './title-header.service';

describe('TitleHeaderService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: TitleHeaderService = TestBed.get(TitleHeaderService);
    expect(service).toBeTruthy();
  });
});
