import {Answer} from './Answer'
export class Question{
    Id: number;
    IsHorizontal: boolean;
    IsMultipleChoice: boolean;
    OrganizationId: number;
    Question: string;
    Tags: string;
    TextBelowQuestion: string;
    UpdatedOn: Date;
    answers: Answer[];
}
