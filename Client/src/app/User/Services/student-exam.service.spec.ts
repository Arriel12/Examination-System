import { TestBed } from '@angular/core/testing';

import { StudentExamService } from './student-exam.service';

describe('SutdentExamService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: StudentExamService = TestBed.get(StudentExamService);
    expect(service).toBeTruthy();
  });
});
