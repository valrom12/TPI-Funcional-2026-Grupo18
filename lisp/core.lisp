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
  (let ((resto (mod tiempou 216)))
    (cond
      ((< resto 90)  'en-rojo)
      ((< resto 210) 'en-verde)
      (t  'en-amarillo))))
;; ========================================================
;; REQUERIMIENTO 3: Sistema de Auditoría
;; FUNCION: auditoria-cambio
;; NATURALEZA: Impura (Efecto secundario: imprime en consola)
;; ESTRATEGIA: Secuencial
;; IMPACTO: No destructiva
;; ========================================================
(defun auditoria-cambio (tiempo color-anterior color-nuevo)
  ;; Utiliza FORMAT para la salida estándar por pantalla
  (format t "Tiempo A: la luz ha cambiado de ~A a ~A%" tiempo color-anterior color-nuevo))
