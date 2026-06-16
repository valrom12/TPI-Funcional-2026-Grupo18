-module(solucion).
-export([transicion/2, timer/1]).

%%% =========================================================
%%% FUNCION: transicion
%%% NATURALEZA: Pura
%%% ESTRATEGIA: Condicional
%%% IMPACTO: No destructiva
%%% =========================================================

transicion(en_rojo, verde) ->
    [en_rojo, cambiar_a_verde];

transicion(en_verde, amarillo) ->
    [en_verde, cambiar_a_amarillo];

transicion(en_amarillo, rojo) ->
    [en_amarillo, cambiar_a_rojo];

transicion(ColorActual, _) ->
    [ColorActual, accion_por_defecto].

%%% =========================================================
%%% FUNCION: timer
%%% NATURALEZA: Pura
%%% ESTRATEGIA: Condicional
%%% IMPACTO: No destructiva
%%% =========================================================

timer(TiempoUnix) ->
    Resto = TiempoUnix rem 216,
    if
        Resto < 90 ->
            en_rojo;
        Resto < 210 ->
            en_verde;
        true ->
            en_amarillo
    end.