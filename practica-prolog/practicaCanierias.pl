% DOMINIO
% codo(Color).
% canio(Color, Longitud).
% canilla(Tipo, Color, Ancho).


/* Punto 1
    Definir un predicado que relacione una cañería con su precio. Una cañería es una lista de piezas. Los precios son:
    codos: $5.
    caños: $3 el metro.
    canillas: las triangulares $20, del resto $12 hasta 5 cm de ancho, $15 si son de más de 5 cm.
 */

precio(codo(_), 5).
precio(canio( _, _), 3).
precio(canilla(triangular, _, _), 20).

precio(canilla(Tipo, _, Ancho), 12):-
    Tipo \= triangular,
    Ancho < 5.

precio(canilla(Tipo, _, Ancho), 15):-
    Tipo \= triangular,
    Ancho > 5.

% Considerando que precio tmb puede recibir una LISTA DE PIEZAS, osea UNA CAÑERIA

precio([], 0).

precio([Pieza | Piezas], Precio):-
    precio(Pieza, PrecioPieza),   
    precio(Piezas, PrecioPiezas),  
    Precio is PrecioPieza + PrecioPiezas.


/* Punto 2
    Definir el predicado puedoEnchufar/2, tal que puedoEnchufar(P1,P2) se verifique si puedo enchufar P1 a la izquierda de P2. Puedo enchufar dos piezas si son del mismo color, o si son de colores enchufables. Las piezas azules pueden enchufarse a la izquierda de las rojas, y las rojas pueden enchufarse a la izquierda de las negras. Las azules no se pueden enchufar a la izquierda de las negras, tiene que haber una roja en el medio. P.ej.

    sí puedo enchufar (codo rojo, caño negro de 3 m).
    sí puedo enchufar (codo rojo, caño rojo de 3 m) (mismo color).
    no puedo enchufar (caño negro de 3 m, codo rojo) (el rojo tiene que estar a la izquierda del negro).
    no puedo enchufar (codo azul, caño negro de 3 m) (tiene que haber uno rojo en el medio).

 */

color(codo(Color), Color).
color(canio(Color, _), Color).
color(canilla(_, Color, _), Color).
punta(extremo(Punta, _), Punta).

puedoEnchufar(PiezaIzq, PiezaDer):- % mismo color
    color(PiezaIzq, Color),
    color(PiezaDer, Color).

puedoEnchufar(PiezaIzq, PiezaDer):- % azul rojo
    color(PiezaIzq, azul),
    color(PiezaDer, rojo).

puedoEnchufar(PiezaIzq, PiezaDer):- % rojo negro
    color(PiezaIzq, rojo),
    color(PiezaDer, negro).


puedoEnchufar(_, PiezaDer):- % extremo derecho
    punta(PiezaDer, derecho).

puedoEnchufar(PiezaIzq, _):- % extremo izquierdo
    punta(PiezaIzq, izquierdo).


/* Punto 3
    Modificar el predicado puedoEnchufar/2 de forma tal que pueda preguntar por elementos sueltos o por cañerías ya armadas.

    P.ej. una cañería (codo azul, canilla roja) la puedo enchufar a la izquierda de un codo rojo (o negro), y a la derecha de un caño azul. Ayuda: si tengo una cañería a la izquierda, ¿qué color tengo que mirar? Idem si tengo una cañería a la derecha.
 */

puedoEnchufar(Canieria, PiezaDer):-
    last(Canieria, PiezaIzq),
    puedoEnchufar(PiezaIzq, PiezaDer).

puedoEnchufar(PiezaIzq, [PiezaDer | _]):-
    puedoEnchufar(PiezaIzq, PiezaDer).


/* Punto 4
    Definir un predicado canieriaBienArmada/1, que nos indique si una cañería está bien armada o no. Una cañería está bien armada si a cada elemento lo puedo enchufar al inmediato siguiente, de acuerdo a lo indicado al definir el predicado puedoEnchufar/2.
 */
pieza(Pieza):- color(Pieza, _).
pieza(Pieza):- punta(Pieza, _).

canieriaBienArmada([_]).

canieriaBienArmada([PiezaIzq, PiezaDer | Piezas]):- % para este caso pieza debe ser SI O SI un ELEMENTO, NO UNA LISTA
    pieza(PiezaIzq),
    pieza(PiezaDer),
    puedoEnchufar(PiezaIzq, PiezaDer),
    canieriaBienArmada([PiezaDer | Piezas]).

% elemeto lista x
% lista elemento x
% lista lista x

canieriaBienArmada([PiezaIzq, PiezaDer | Piezas]):-
    not(pieza(PiezaIzq)),
    flatten([PiezaIzq, PiezaDer, Piezas], PiezasCombinadas),
    canieriaBienArmada(PiezasCombinadas).

canieriaBienArmada([PiezaIzq, PiezaDer | Piezas]):-
    not(pieza(PiezaDer)),
    flatten([PiezaIzq, PiezaDer, Piezas], PiezasCombinadas),
    canieriaBienArmada(PiezasCombinadas).


/* Punto 5
    Modificar el predicado puedoEnchufar/2 para tener en cuenta los extremos, que son piezas que se agregan a las posibilidades. De los extremos me interesa de qué punta son (izquierdo o derecho), y el color, p.ej. un extremo izquierdo rojo. Un extremo derecho no puede estar a la izquierda de nada, mientras que un extremo izquierdo no puede estar a la derecha de nada. Verificar que canieriaBienArmada/1 sigue funcionando. 

    Ayuda: resolverlo primero sin listas, y después agregar las listas. Lo de las listas sale en forma análoga a lo que ya hicieron, ¿en qué me tengo que fijar para una lista si la pongo a la izquierda o a la derecha?. 

    VER EN PUNTO 2  
 */


/* Punto 6
    Modificar el predicado canieriaBienArmada/1 para que acepte cañerías formadas por elementos y/u otras cañerías. P.ej. una cañería así: codo azul, [codo rojo, codo negro], codo negro  se considera bien armada.

    VER EN PUNTO 4
 */


/* Punto 7
    Armar las cañerías legales posibles a partir de un conjunto de piezas (si tengo dos veces la misma pieza, la pongo dos veces, p.ej. [codo rojo, codo rojo] )
 */


canieriasLegales(Piezas, Canieria):-
    subconjunto(Piezas, Canieria),
    canieriaBienArmada(Canieria).

subconjunto(_,[]).

subconjunto(Conjunto, [Elemento | OtrosElementos]):-
    select(Elemento, Conjunto, RestoConjunto),
    subconjunto(RestoConjunto, OtrosElementos).


    
    

    



    
    
    







