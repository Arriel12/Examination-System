import { StudentQuestion } from './StudentQuestion';

export class StudentExam
{
    examId: string;
    language: string;
    name: string;
    openingText: string;
    passingGrade: number;
    id: string;
    questions: StudentQuestion[]; 
   
}