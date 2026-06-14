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

;; =================================================================
;; REQUERIMIENTO 7: Aseguramiento de la calidad
;; FUNCION: asfuramiento-calidad
;; NATURALEZA: Impura
;; ESTRATEGIA: Función de Orden Superior
;; IMPACTO: No destructiva
;; =================================================================

;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 1: transicion
;; -----------------------------------------------------------------

(transicion 'en-rojo 'verde)

(transicion 'en-rojo 'amarillo)

;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 2: timer
;; -----------------------------------------------------------------

(timer 50)
;; Devuelve: EN-ROJO

(timer 100)
;; Devuelve: EN-VERDE

(timer 212)
;; Devuelve: EN-AMARILLO

;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 3: auditoria-cambio
;; -----------------------------------------------------------------

(auditoria-cambio 1700000000 'en-rojo 'en-verde)

(auditoria-cambio 0 "ROJO" "VERDE")

;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 4a: duracion-ciclo
;; -----------------------------------------------------------------


(duracion-ciclo 90 6 120)

(duracion-ciclo 45.5 3.2 60.0)
;; Devuelve: 108.7

;; Generación de Errores: Pasar argumentos que no sean números al operador aritmético +
;; (duracion-ciclo 90 "6 segundos" 120) ;; ERROR: "6 segundos" no es un número.


;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 4b: recomendacion-ciclo
;; -----------------------------------------------------------------

;; Camino Normal: Duración óptima intermedia
(recomendacion-ciclo 90)

(recomendacion-ciclo 20)

(recomendacion-ciclo 180)

;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 5: ciclos-por-tiempo
;; -----------------------------------------------------------------


(ciclos-por-tiempo 60)

(ciclos-por-tiempo 2)

;; -----------------------------------------------------------------
;; PRUEBAS PARA EL REQUERIMIENTO 6: distribucion-temporal
;; -----------------------------------------------------------------

(distribucion-temporal) ;; Devuelve: ((ROJO 41.666668) (AMARILLO 2.7777777) (VERDE 55.555557))

;; Camino Alternativo: Al no poseer parámetros de entrada, no presenta caminos alternativos de ejecución.
