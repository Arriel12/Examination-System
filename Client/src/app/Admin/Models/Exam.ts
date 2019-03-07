import { TrustedStyleString } from '@angular/core/src/sanitization/bypass';
import { SelectableQuestion } from './SelectableQuestion';

export class Exam{
    Id: number;
    Language: string;
    Name: string;
    OpeningText: string;
    OrganaizerEmail: string;
    PassingGrade: number;
    ShowAnswer: boolean;
    CertificateUrl: string;
    SuccessText: string;
    FailText: string;
    SuccessMailSubject: string;
    SuccessMailBody: string;
    FailMailSubject: string;
    FailMailBody: string;
    OrganizationId: number;
    CategoryId: number;
    UpdatedOn: Date;
    questions: any[];
    url: string;
}