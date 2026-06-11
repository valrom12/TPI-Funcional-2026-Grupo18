;; =================================================================
;; TPI- SISTEMAS DE SEMAFOROS INTELIGENTES 
;; Lenguaje: Common Lisp
;; ======================================================
;; CARGA DE LIBRERIA LOCAL-TIME
;; ======================================================
(ql:quickload :local-time)
;; =================================================================
;; REQUERIMIENTO 1: Estados de Transición 
;; =================================================================
;; FUNCION: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA: condicional  
;; IMPACTO: no destructiva
;; =================================================================

(defun transicion (color-actual cambiar-a)
  (cond
    ((and (equal color-actual 'en-rojo) (equal cambiar-a 'verde))
     (list color-actual "cambiar-a-verde"))

    ((and (equal color-actual 'en-verde) (equal cambiar-a 'amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ((and (equal color-actual 'en-amarillo) (equal cambiar-a 'rojo))
     (list color-actual "cambiar-a-rojo"))

    (t (list color-actual 'accion-por-defecto))
  )
)

;; =================================================================
;; REQUERIMIENTO 2: Temporizador Automático 
;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura
;; ESTRATEGIA: Condicional
;; IMPACTO: No destructiva
;; ========================================================

(defun timer (tiempou)
  (let ((resto (mod tiempou 216)))
    (cond
      ((< resto 90)  'en-rojo)
      ((< resto 210) 'en-verde)
      (t  'en-amarillo))
  )
)

;; ========================================================
;; REQUERIMIENTO 3: Sistema de Auditoría
;; FUNCION: auditoria-cambio
;; NATURALEZA: Impura (Efecto secundario: imprime en consola)
;; ESTRATEGIA: Secuencial
;; IMPACTO: No destructiva
;; ========================================================
(defun auditoria-cambio (tiempo color-anterior color-nuevo)
 (let ((fecha
         (local-time:format-timestring
          nil
          (local-time:unix-to-timestamp tiempo)
          :format '(:year "-" :month "-" :day
                    " "
                    :hour ":" :min ":" :sec))))

    (format t
            "Tiempo ~A: la luz ha cambiado de ~A a ~A~%"
            fecha
            color-anterior
            color-nuevo)
  )
)

;; ========================================================
;; REQUERIMIENTO 4a: Análisis de Ciclos (Duración)
;; FUNCION: duracion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA: Composición
;; IMPACTO: No destructiva
;; ========================================================
(defun duracion-ciclo (t-rojo t-amarillo t-verde)
  (+ t-rojo t-amarillo t-verde)
)

;; ========================================================
;; REQUERIMIENTO 4b: Recomendación de Ciclos
;; FUNCION: recomendacion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA: Condicional
;; IMPACTO: No destructiva
;; ========================================================
(defun recomendacion-ciclo (duracion)
  (cond
    ((< duracion 35) "El ciclo es demasiado corto. Dificil acomodacion psicologica.")
    ((> duracion 150) "El ciclo es demasiado largo. Dificil acomodacion psicologica.")
    (t "El ciclo esta dentro del rango optimo (35-150 segundos).")
  )
)

;; ========================================================
;;  REQUERIMIENTO 5: Planificación Temporal
;; FUNCION: ciclos-por-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA: Composicion
;; IMPACTO: No destructiva
;; ========================================================

(defun ciclos-por-tiempo (minutos)
  (floor
   (/ (* minutos 60)
      (duracion-ciclo 90 6 120))
  )
)

;; ========================================================
;;  REQUERIMIENTO 6: Informe de Distribución Temporal 
;; ========================================================
;; FUNCION: distribucion-temporal
;; NATURALEZA: Pura
;; ESTRATEGIA: Composicion
;; IMPACTO: No destructiva
;; ========================================================

(defun distribucion-temporal ()

  (let ((ciclo (duracion-ciclo 90 6 120)))

    (list

     (list 'rojo
           (* (/ 90.0 ciclo) 100)
      )

     (list 'amarillo
           (* (/ 6.0 ciclo) 100)
      )

     (list 'verde
           (* (/ 120.0 ciclo) 100)
      )
    )
  )
)

