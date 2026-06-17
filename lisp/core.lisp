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
;; FUNCIÓN: timer-semaforo 
;; NATURALEZA: Pura
;; ESTRATEGIA: Condicional
;; IMPACTO: No destructiva
;; ========================================================

(defun timer-semaforo  (tiempou)
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
;; FUNCION: aseguramiento-calidad
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
;; PRUEBAS PARA EL REQUERIMIENTO 2: timer-semaforo
;; -----------------------------------------------------------------

(timer-semaforo 50)
;; Devuelve: EN-ROJO

(timer-semaforo 100)
;; Devuelve: EN-VERDE

(timer-semaforo 212)
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


;; -----------------------------------------------------------------
;; ITERACION 2
;; -----------------------------------------------------------------

;; ========================================================
;; FUNCIÓN: transicion-intermitente
;; NATURALEZA: Pura
;; ESTRATEGIA: Función Predicado
;; IMPACTO: No destructiva
;; NOTA: Incluye estado en-amarillo-intermitente entre cada transición
;; ========================================================

(defun transicion-intermitente (color-actual cambiar-a)
  (cond
    ((and (equal color-actual 'en-rojo) (equal cambiar-a 'en-amarillo-intermitente))
     (list color-actual "cambiar-a-amarillo-intermitente"))

    ((and (equal color-actual 'en-amarillo-intermitente) (equal cambiar-a 'en-verde))
     (list color-actual "cambiar-a-verde"))

    ((and (equal color-actual 'en-verde) (equal cambiar-a 'en-amarillo-intermitente))
     (list color-actual "cambiar-a-amarillo-intermitente"))

    ((and (equal color-actual 'en-amarillo-intermitente) (equal cambiar-a 'en-amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ((and (equal color-actual 'en-amarillo) (equal cambiar-a 'en-amarillo-intermitente))
     (list color-actual "cambiar-a-amarillo-intermitente"))

    ((and (equal color-actual 'en-amarillo-intermitente) (equal cambiar-a 'en-rojo))
     (list color-actual "cambiar-a-rojo"))

    (t
     (list color-actual 'accion-por-defecto))))

;; ========================================================
;; FUNCIÓN: timer-semaforo-intermitente 
;; NATURALEZA: Pura
;; ESTRATEGIA: Función Predicado
;; IMPACTO: No destructiva
;; NOTA: Ciclo de 225s con intermitencias entre cada transición
;; ========================================================

(defun timer-semaforo-intermitente  (tiempou)
  (let ((resto (mod tiempou 225)))
    (cond
      ((< resto 90)  'en-rojo)                
      ((< resto 93)  'en-amarillo-intermitente)   
      ((< resto 213) 'en-verde)                  
      ((< resto 216) 'en-amarillo-intermitente)   
      ((< resto 222) 'en-amarillo)                
      (t             'en-amarillo-intermitente)   
      )))

;; ========================================================
;; FUNCIÓN: duracion-ciclo-intermitente
;; NATURALEZA: Pura
;; ESTRATEGIA: Función Simple
;; IMPACTO: No destructiva
;; NOTA: Incluye 3 períodos de intermitencia de 3s cada uno
;; ========================================================

(defun duracion-ciclo-intermitente (t-rojo t-amarillo t-verde)
  (+ t-rojo t-amarillo t-verde (* 3 3)))

;; ========================================================
;; EXTENSION 2: Persistencia de Datos
 ;; FUNCION: informe
 ;; NATURALEZA: Impura
 ;; ESTRATEGIA: Funciones de Orden Superior (mapc) 
;; IMPACTO: No destructiva
 ;; ========================================================

(defun informe (datos)
 (with-open-file (stream "informe-ejecucion-semaforo.txt"
 :direction :output
 :if-exists :supersede
 :if-does-not-exist :create)
 (format stream "Informe de Ejecución del Sistema Semafórico~%")
 (format stream "=========================================~%")
 ;; Se utiliza mapc por ser la función de orden superior óptima para iterar aplicando
 ;; efectos secundarios sin generar una lista nueva en memoria. 
(mapc #'(lambda (registro)
 (let ((fecha-hora (first registro)) 
(color-anterior (second registro)) 
(color-nuevo (third registro)))
 (format stream "~A - Transición: ~A → ~A~%" 
fecha-hora color-anterior color-nuevo))) datos) 
(format stream "~%--- Fin del Informe ---")))
;; Camino Normal: Se pasa una lista con registros simulados (con fechas legibles ya procesadas) ;; Ejecución:
 ;; (informe '(("2026-06-04 14:30:15" "ROJO" "VERDE")
 ;; ("2026-06-04 14:32:15" "VERDE" "AMARILLO") 
;; ("2026-06-04 14:32:21" "AMARILLO" "ROJO"))) 
;; Devuelve: "--- Fin del Informe ---" y crea el archivo "informe-ejecucion-semaforo.txt"

;; Camino Alternativo: Lista de datos vacia (el sistema no entra en el mapc y genera un informe limpio) 
;; Ejecucion:
 ;; (informe nil)
 ;; Devuelve: "--- Fin del Informe ---" con la cabecera y el cierre del archivo vacíos

;; Generación de Errores: Pasar un atomo en lugar de una lista estructurada impedira que mapc opere.
 ;; (informe "registro-unico") 
;; ERROR: El argumento no es una lista sobre la cual iterar


;; ======================================================
;; CARGA DE LIBRERIA LOCAL-TIME MEDIANTE QUICKLISP
;; ======================================================

(ql:quickload :local-time)

;; ========================================================
;; REQUERIMIENTO 3: Sistema de Auditoría (Modificado)
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
          :format '( :year "-" (:month 2) "-" (:day 2) 
                    " " 
                    (:hour 2) ":" (:min 2) ":" (:sec 2) ))))

    (format t 
            "~A : la luz ha cambiado de ~A a ~A~%" 
            fecha 
            color-anterior 
            color-nuevo)
  )
)
;; Llamada de prueba
(auditoria-cambio 1781631000 'en-verde 'en-amarillo)

;; Salida esperada en consola:
;; 2026-06-16 14:30:00 : la luz ha cambiado de EN-VERDE a EN-AMARILLO
