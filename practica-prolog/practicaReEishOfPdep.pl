/* Punto 1 */

% Dominio -> Jugadores

jugador(ana).
jugador(beto).
jugador(carola).
jugador(dimitri).

juegaCon(ana, romanos).
juegaCon(beto, incas).
juegaCon(carola, romanos).
juegaCon(dimitri, romanos).

desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, emplumado).
desarrollo(ana, laminas).
desarrollo(beto, herreria).
desarrollo(beto, forja).
desarrollo(beto, fundicion).
desarrollo(carola, herreria).
desarrollo(dimitri, herreria).
desarrollo(dimitri, fundicion).


/* Punto 2 */

expertoEnMetales(Jugador):-
    desarrollo(Jugador, herreria),
    desarrollo(Jugador, forja),
    cumpleConLaUltimaCondicion(Jugador).

cumpleConLaUltimaCondicion(Jugador):-
    desarrollo(Jugador, fundicion).

cumpleConLaUltimaCondicion(Jugador):-
    juegaCon(Jugador, romanos).


/* Punto 3 */

popular(Civilizacion):-
    civilizacion(Civilizacion),
    findall(Jugador, juegaCon(Jugador, Civilizacion), Jugadores),
    length(Jugadores, Cantidad),
    Cantidad > 1.
    
civilizacion(Civilizacion):- distinct(Civilizacion, juegaCon(_, Civilizacion)). 


/* Punto 4 */

tieneAlcanceGlobal(Tecnologia):-
    forall(jugador(Jugador), desarrollo(Jugador, Tecnologia)).
    

/* Punto 5 */

lider(Civilizacion):-
    civilizacion(Civilizacion),
    findall(OtraTecnologia, (alcanzo(OtraCivilizacion, OtraTecnologia), OtraCivilizacion \= Civilizacion), OtrasTecnologias),
    list_to_set(OtrasTecnologias, SetTecnologias),
    forall(member(Tecnologia, SetTecnologias), alcanzo(Civilizacion, Tecnologia)).
    
alcanzo(Civilizacion, Tecnologia):-
    desarrollo(Jugador, Tecnologia),
    juegaCon(Jugador, Civilizacion).
    

% Dominio -> Unidades
unidad(Unidad):- vida(Unidad, _).
unidad(campeon(_)).

/* Punto 6 */

tiene(ana, jinete(caballo)).
tiene(ana, piquero(conEscudo, 1)).
tiene(ana, piquero(sinEscudo, 2)).
tiene(beto, campeon(100)).
tiene(beto, campeon(80)).
tiene(beto, piquero(conEscudo, 1)).
tiene(beto, jinete(camello)).
tiene(carola, piquero(sinEscudo, 3)).
tiene(carola, piquero(conEscudo, 2)).


/* Punto 7 */

vida(jinete(camello), 80).
vida(jinete(caballo), 90).
vida(campeon(Vida), Vida).    % Cada campeon tiene su propia vida
vida(piquero(sinEscudo, 1), 50).
vida(piquero(sinEscudo, 2), 65).
vida(piquero(sinEscudo, 3), 70).
vida(piquero(conEscudo, 1), 55).
vida(piquero(conEscudo, 2), 71.5).
vida(piquero(conEscudo, 3), 77).

conMasVida(Unidad, Jugador):-
    jugador(Jugador),
    findall(UnidadDelJugador, tiene(Jugador, UnidadDelJugador), UnidadesDelJugador),
    masViva(Unidad, UnidadesDelJugador).

masViva(UnidadConMasVida, Unidades):-
    maplist(vida, Unidades, VidaUnidades),
    max_member(MayorVida, VidaUnidades),
    nth0(Posicion, VidaUnidades, MayorVida),
    nth0(Posicion, Unidades, UnidadConMasVida).
    

/* Punto 8 */

% Tienen ventajas sobre otras
leGana(jinete(_), campeon(_)).
leGana(campeon(_), piquero(_,_)).
leGana(piquero(_,_), jinete(_)).
leGana(jinete(camello), jinete(caballo)).

% Si no tienen ventajas, se compara la vida
leGana(Unidad, OtraUnidad):-
    vida(Unidad, Vida),
    vida(OtraUnidad, OtraVida),
    Vida > OtraVida.


/* Punto 9 */

sobreviveAUnAsedio(Jugador):-
    jugador(Jugador),
    findall(piquero, tiene(Jugador, piquero(conEscudo, _)), PiquerosConEscudo),
    findall(piquero, tiene(Jugador, piquero(sinEscudo, _)), PiquerosSinEscudo),
    length(PiquerosConEscudo, CantidadConEscudo),
    length(PiquerosSinEscudo, CantidadSinEscudo),
    CantidadConEscudo > CantidadSinEscudo.
    

/* Punto 10 */
% a) Dependencias

depende(emplumado, herreria).
depende(forja, herreria).
depende(laminas, herreria).
depende(punzon, emplumado).
depende(fundicion, forja).
depende(malla, laminas).
depende(horno, fundicion).
depende(placas, malla).

depende(collera, molino).
depende(arado, collera).


% b) 

puedeDesarrollar(Jugador, Tecnologia):-
    jugador(Jugador),
    tecnologia(Tecnologia),
    not(desarrollo(Jugador, Tecnologia)),
    desarrolloDependencias(Jugador, Tecnologia).

desarrolloDependencias(Jugador, Tecnologia):-
    depende(Tecnologia, TecnologiaRequerida),
    desarrollo(Jugador, TecnologiaRequerida).

desarrolloDependencias(_, molino).
desarrolloDependencias(_, herreria).

tecnologia(Tecnologia):- distinct(Tecnologia, depende(Tecnologia, _)).
tecnologia(herreria).
tecnologia(molino).





    
