# Sistema de semaforos inteligentes- Grupo 18

## Trabajo practico integrador 2026: Programacion Funcional
**Grupo:** 18
**Fecha de entrega**: 16 de junio
**Lenguaje asignado**: Erlang

## Integrantes 

Gonzalez, Rocio Anabel - @Anabel0710
Romani, Valentino - @valrom12
Gomez, Matias Gabriel - @MatiasGabriel
Lafuente, Noelia Magali -  @
Bereciartua Serpa, Osvaldo Agustin - @

## Objetivo
El objetivo es modelar un sistema de semáforos inteligentes utilizando **Common Lisp** utilizando los principios del paradigma funcional:
 **funciones puras**
 **inmutabilidad**
 **Composicion funcional**
 **Ausencia de estructuras imperativas de iteracion**
 **Modelado mediante funciones y expresiones**

Ademas, incluye auditoría con fechas legibles gracias a la librería **local-time** y una comparativa con Erlang.

# Funcionalidades implementadas:

## Requerimiento 1
* Funcion transicion 
* Control de estados del semaforo 
* Validacion de transiciones

## Requerimiento 2
* Funcion timer
* Calculo del color segun el tiempo

## Requerimiento 3
* Sistema de auditoria 
* Registro de cambios de estado 
* Uso de la libreria local-time para mostrar fechas legibles 

## Requerimiento 4
* Calculo de duracion del ciclo completo
* Recomendacion sobre la duracion del ciclo 

## Requerimiento 5
* Calculo de ciclos completos para una determinada cantidad de minutos

## Requerimiento 6
* Distribucion porcentual del tiempo de cada color durante 1 hora 

## Requerimiento 7
* Ejemplos de uso
* casos normales 
* casos alternativos 
* casos invalidos

## Tecnologias usadas: 

* Cammon Lisp
* local-time
* Quicklisp
* Git 
* GitHub 


## Estructura del repositorio
```
TPI-Funcional-2026-Grupo18/
├── lisp/
│   └── core.lisp
│
├── comparativa/
│   └── solucion.erl
│
├── docs/
│   ├── INFORME.md
│   └── HONOR.md
│
└── README.md
```


