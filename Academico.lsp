;====================================================================================================================
(defun ALUNOS? (BD)
        (cond   ((null (car BD)) NIL)
                ((null (caar BD)) NIL)
                (t  
                    (remove-duplicates
                        (append (cdadar BD)
                        (ALUNOS? (cdr BD))
                        )
                    )
                )
        )
)
;====================================================================================================================
(defun PROFESSORES? (BD)
        (cond   ((null (car BD)) NIL)
                ((null (caar BD)) NIL)
                (t  
                    (remove-duplicates
                        (append (list (caadar BD) (caddar BD))
                        (PROFESSORES? (cdr BD))
                        )
                    )
                )
        )
)
;====================================================================================================================
(defun DISCIPLINAS? (BD)
        (cond   ((null (car BD)) NIL)
                ((null (caar BD)) NIL)
                (t  (append (cons (caar BD) nil)
                    (DISCIPLINAS? (cdr BD))
                    )
                )
        )
)
;====================================================================================================================
(defun get_disp (DISCIPLINA BD)
        (cond   ((null (car BD)) NIL)
                ((null (caar BD)) NIL)
                ((string= DISCIPLINA (caar BD)) 
                    (car BD)
                )
                (t  (get_disp DISCIPLINA (cdr BD)))
        )
)
;====================================================================================================================
(DEFUN VINCULADOS? (DISCIPLINA BD)
        (cond   ((null (get_disp DISCIPLINA BD)) NIL)   ;disciplina nao existe
                (t 
                    (list (caadr (get_disp DISCIPLINA BD))
                        (caddr (get_disp DISCIPLINA BD))
                    )
                )
        )
)
;====================================================================================================================
(DEFUN MATRICULADOS? (DISCIPLINA TURMA BD)
        (cond   ((null (get_disp DISCIPLINA BD)) NIL)   ;disciplina nao existe
                ;DISCIPLINA EXIST
                ( (AND (= TURMA 1) (NOT (null (cadr (get_disp DISCIPLINA BD)))) )
                    (cdadr (get_disp DISCIPLINA BD))
                )
                ( (AND (= TURMA 2) (NOT (null (cddr (get_disp DISCIPLINA BD)))) )
                    (cdddr (get_disp DISCIPLINA BD))
                )
                (t NIL) ; TURMA INVALIDA
        )
)
;====================================================================================================================
;====================================================================================================================
;====================================================================================================================

(defun MATRICULAR (ALUNOS DISCIPLINAS TURMA BD)
    ;checa se disciplina existe, se não cria.// se sim, incrementa 
    (cond   ((null (car DISCIPLINAS))  NIL)
            ;((null (car ALUNOS))  NIL)
            ((null (get_disp (car DISCIPLINAS) BD))
                ;NAO EXISTE A DISCIPLINA, CRIEMOS
                (let (
                        (L1 (cons (cons (car DISCIPLINAS) (cons (cons nil ALUNOS) (cons nil nil) ) ) nil))
                        (L2 (cons (cons (car DISCIPLINAS) (cons (cons nil nil)    (cons nil ALUNOS) ) ) nil))
                    )
                    (cond   ((= TURMA 1)
                                (append BD
                                L1
                                )
                            )

                            ((= TURMA 2)
                                (append BD
                                L2
                                )
                            )

                            (t NIL) ;turma invalida!!
                    )
                )
                
            )
            (t  ;EXISTE A DISCIPLINA, INSCREVE OS ALUNOS NA TURMA
                NIL
            
            )
    )
)








;(DEFUN CANCELAR-MATRICULA (ALUNOS DISCIPLINAS TURMA BD) ... )
;(DEFUN VINCULAR (PROFESSORES DISCIPLINAS BD) ... )
;(DEFUN REMOVER-VINCULO (PROFESSORES DISCIPLINAS BD) ... )


;(DEFUN CURSA? (ALUNO BD) ... )
;(DEFUN MINISTRA? (PROFESSOR BD) ... )
