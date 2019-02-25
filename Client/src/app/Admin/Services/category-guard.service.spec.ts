import { TestBed } from '@angular/core/testing';

import { CategoryGuardService } from './category-guard.service';

describe('CategoryGuardService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: CategoryGuardService = TestBed.get(CategoryGuardService);
    expect(service).toBeTruthy();
  });
});
