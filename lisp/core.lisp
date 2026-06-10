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

(defun transicion (color-actual cambiar-a)
  (cond
    ((and (equal color-actual 'en-rojo) (equal cambiar-a 'verde))
     (list color-actual "cambiar-a-verde"))

    ((and (equal color-actual 'en-verde) (equal cambiar-a 'amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ((and (equal color-actual 'amarillo) (equal cambiar-a 'rojo))
     (list color-actual "cambiar-a-rojo"))

    (t (list color-actual 'accion-por-defecto))))


;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura
;; ESTRATEGIA: Función Predicado
;; IMPACTO: No destructiva
;; ========================================================

(defun timer (tiempou)
  (let (resto)
    (setq resto (mod tiempou 216))
      (cond 
          ((< resto 90) 'en-rojo)
          ((< resto 210) 'en-verde)
          (t 'en-amarillo))))
;; ========================================================
;; REQUERIMIENTO 3: SISTEMA DE AUDITORÍA
;; Requiere Quicklisp + Local-Time
;; ========================================================

;; ========================================================
;; FUNCIÓN: epoch->legible
;; NATURALEZA: Pura
;; IMPACTO: No destructiva
;; ========================================================

(defun epoch->legible (epoch)
  (let ((timestamp (local-time:unix-to-timestamp epoch)))
    (concatenate
     'string
     "["
     (local-time:format-timestring
      nil
      timestamp
      :format '((:year 4) #\- (:month 2) #\- (:day 2)
                #\space
                (:hour 2) #\: (:min 2) #\: (:sec 2)))
     "]")))

;; ========================================================
;; FUNCIÓN: log-cambio-estado
;; NATURALEZA: Impura
;; IMPACTO: No destructiva
;; ========================================================

(defun log-cambio-estado (epoch color-anterior color-nuevo)
  (format t
          "Tiempo ~a: la luz ha cambiado de ~a a ~a~%"
          (epoch->legible epoch)
          color-anterior
          color-nuevo))

;; ========================================================
;; FUNCIÓN: auditar-ciclo
;; NATURALEZA: Impura
;; ESTRATEGIA: Recursiva de Cola
;; IMPACTO: No destructiva
;; ========================================================

(defun auditar-ciclo (timestamps color-anterior acumulador)
  (if (null timestamps)
      (reverse acumulador)

      (let* ((epoch (car timestamps))
             (color-nuevo (timer epoch))
             (registro (list epoch
                             color-anterior
                             color-nuevo)))

        (when (not (eq color-anterior color-nuevo))
          (log-cambio-estado
           epoch
           color-anterior
           color-nuevo))

        (auditar-ciclo
         (cdr timestamps)
         color-nuevo
         (cons registro acumulador)))))
