;; =================================================================
;; TPI- SISTEMAS DE SEMAFOROS INTELIGENTES 
;; Lenguaje: Common Lisp
;; =================================================================
;; REQUERIMIENTO 1
;; =================================================================
;; FUNCION: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA: condicional  
;; IMPACTO: no destructiva
;; =================================================================

(defun transicion ( color-actual cambiar-a)
  (cond
    ((and (eq color-actual 'rojo) (eq cambiar-a 'amarillo))
     (list color-actual "cambiar-a-amarillo"))
    ((and (eq color-actual 'amarillo) (eq cambiar-a 'verde))
     (list color-actual "cambiar-a-verde")
    )
    ((and (eq color-actual 'verde) (eq cambiar-a 'rojo))
     (list color-actual "cambiar-a-rojo")
    )
    (t (list color-actual 'accion-por-defecto))
    )
)