import { StudentAnswer } from './StudentAnswer';

export class StudentQuestion {
    id: number;
    isHorizontal: boolean;
    isMultipleChoice: boolean;
    question: string;
    textBelow: string;
    answers: StudentAnswer[];
    isAnswered: boolean;
}