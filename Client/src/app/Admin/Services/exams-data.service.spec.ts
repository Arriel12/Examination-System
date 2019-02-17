import { TestBed } from '@angular/core/testing';

import { ExamsDataService } from './exams-data.service';

describe('ExamsDataService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ExamsDataService = TestBed.get(ExamsDataService);
    expect(service).toBeTruthy();
  });
});
