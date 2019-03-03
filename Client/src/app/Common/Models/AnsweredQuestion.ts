import { AnsweredAnswer } from './AnsweredAnswer';

export class AnsweredQuestion
{
    Question: string;
    Id: number;
    IsCorrect: boolean;
    answers: AnsweredAnswer[];
    
}