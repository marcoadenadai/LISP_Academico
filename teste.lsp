(
    SETQ BD1
    (list 
        (cons `NOME_DISP01 (cons (cons `1/NOME_PROF_T1 (list `1/A1_T1 `1/A2_T1 `1/A3_T1 `1/A4_T1))
                                   (cons `1/NOME_PROF_T2 (list `1/A1_T2 `1/A2_T2 `1/A3_T2 `1/A4_T2))
                            )
        )
        (cons `NOME_DISP02 (cons (cons `2/NOME_PROF_T1 (list `2/A1_T1 `2/A2_T1 `2/A3_T1 `2/A4_T1))
                                   (cons `2/NOME_PROF_T2 (list `2/A1_T2 `2/A2_T2 `2/A3_T2 `2/A4_T2))
                            )
        )
        (cons `NOME_DISP03 (cons (cons `3/NOME_PROF_T1 (list `3/A1_T1 `3/A2_T1 `3/A3_T1 `3/A4_T1))
                                   (cons `3/NOME_PROF_T2 (list `3/A1_T2 `3/A2_T2 `3/A3_T2 `3/A4_T2))
                            )
        )
    )
)

(SETQ BD1 `NIL)

;(car bd1) = 1 disp
;(cadr bd1) = 2 disp
;(caddr bd1) = 3 disp...
;(car (disp)) = NOME DISCIPLINA
;(caadr (disp)) = NOME PROF T1
;(cdadr (disp)) = LISTA ALUNOS T1
;(caddr (disp)) = NOME PROF T2 
;(cdddr (disp)) = LISTA ALUNOS T2


(defun MATRICULAR (ALUNOS DISCIPLINAS TURMA BD)
    ;checa se disciplina existe, se não cria.// se sim, incrementa 
    (cond   ((null (car DISCIPLINAS))  NIL)
            ;((null (car ALUNOS))  NIL)
            ((null (get_disp (car DISCIPLINAS) BD))
                ;NAO EXISTE A DISCIPLINA, CRIEMOS
                (cond   ((= TURMA 1)
                            (append BD
                            (cons 
                                (cons (car DISCIPLINAS)
                                    (cons 
                                        (cons nil ALUNOS)
                                        (cons nil nil)
                                    )
                                )
                            nil)
                            )
                        )

                        ((= TURMA 2)
                            (append BD
                            (cons 
                                (cons (car DISCIPLINAS) 
                                    (cons 
                                        (cons nil nil)
                                        (cons nil ALUNOS)
                                    )
                                )
                            nil)
                            )
                        )

                        (t NIL) ;turma invalida!!
                )
                
            )
            (t  ;EXISTE A DISCIPLINA, INSCREVE OS ALUNOS NA TURMA
                NIL
            
            )
    )
)