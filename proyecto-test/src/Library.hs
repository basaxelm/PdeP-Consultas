{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
module Library where
import PdePreludat
import ShowFunction

-- Dominio

type Palo   = String
type Numero = Number
type Carta  = (Numero, Palo)
type Mano   = [Carta]

numero = fst
palo = snd

palos = ["Corazones", "Picas", "Tréboles", "Diamantes"]
mesaQueMasAplauda = [jamesBond, leChiffre, felixLeiter]

pokerDeAses    = [(1,"Corazones"), (1,"Picas"), (1,"Tréboles"), (1,"Diamantes"), (10,"Diamantes")]
fullDeJokers   = [(11,"Corazones"), (11,"Picas"), (11,"Tréboles"), (10,"Diamantes"), (10,"Picas")]
piernaDeNueves = [(9,"Corazones"), (9,"Picas"), (9,"Tréboles"), (10,"Diamantes"), (4,"Copas")]

data Jugadores = Jugadores{
                nombre          :: String,
                mano            :: Mano,
                bebidaPreferida :: String
            } deriving Show

jamesBond = Jugadores{
                nombre          = "Bond... James Bond",
                mano            = pokerDeAses,
                bebidaPreferida = "Martini... shaken, not stirred"
            }

leChiffre = Jugadores{
                nombre          = "Le Chiffre",
                mano            = fullDeJokers,
                bebidaPreferida = "Gin"
            }

felixLeiter = Jugadores{
                nombre          = "Felix Leiter",
                mano            = piernaDeNueves,
                bebidaPreferida = "Whisky"
            }

-- Funciones
{- 1A mayorSegun/3, que dada una función y dos valores nos devuelve aquel valor que hace mayor a la función (en caso de igualdad, cualquiera de los dos). -}

mayorSegun f valor1 valor2 
    | f valor1  > f valor2 = valor1
    | otherwise            = valor2

{- 1B maximoSegun/2, que dada una función y una lista de valores nos devuelve aquel valor de la lista que hace máximo a la función. -}

maximoSegun f lista = foldl1 (mayorSegun f) lista

{- 1C sinRepetidos/1, que dada una lista devuelve la misma sin elementos repetidos. Los elementos tienen que aparecer en el mismo orden que en la lista original (la primera ocurrencia de la lista de izquierda a derecha). -}

sinRepetidos [] = []
sinRepetidos (x:xs) = x : (sinRepetidos . filter (x/=)) xs


{- 2A esoNoSeVale/1, que se cumple para una carta inválida, ya sea por número o por palo (ver arriba cómo tiene que ser una carta). -}

esoSeVale :: Carta -> Bool
numerosValidos = [1..13] 
esoSeVale carta = numero carta `elem` numerosValidos && palo carta `elem` palos

esoNoSeVale :: Carta -> Bool
esoNoSeVale = not.esoSeVale

{- 2B manoMalArmada/1, que dado un jugador, nos indica si tiene una mano mal armada. Esto es cuando sus cartas no son exactamente 5, o alguna carta es inválida. -}

manoMalArmada :: Jugadores -> Bool
manoMalArmada jugador = length (mano jugador) /= 5 || any esoNoSeVale (mano jugador)


{- 3 Dada una lista de cartas, hacer las funciones que verifican si las mismas forman un juego dado, según las siguientes definiciones:
    par       --> tiene un número que se repite 2 veces
    pierna    --> tiene un número que se repite 3 veces
    color     --> todas sus cartas son del mismo palo
    fullHouse --> es, a la vez, par y pierna
    poker     --> tiene un número que se repite 4 veces
    otro      --> se cumple para cualquier conjunto de cartas -}

ocurrenciasDe x lista = length . filter (== x) $ lista


-- Any selecciona un elemento de la lista: en este caso una carta de la mano 
-- De esa carta se obtiene el numero usando esa funcion (numero = fst porque es una tupla)
-- Por la definicion de ocurrenciasDe, conviene usar flip para no modificar su definicion
-- De esta forma ocurrenciasDe :: [a] -> a -> Number, para luego comparar ese Number con cantidad== , asi con todos los elems
-- Si alguno cumple, entonces ocurrenciasDeNumeros = True por la funcion Any

juegoQueFormanConNum :: Number -> Mano -> Bool
juegoQueFormanConNum cantidad mano = any (((==cantidad) . flip ocurrenciasDe (map numero mano)) . numero) mano

esPar mano = juegoQueFormanConNum 2 mano

esPierna mano = juegoQueFormanConNum 3 mano

esColor mano = all (((==5) . flip ocurrenciasDe (map palo mano)) . palo) mano -- se cambia numero por palo

esFullHouse mano = esPar mano && esPierna mano

esPoker mano = juegoQueFormanConNum 4 mano

otro :: Mano -> Bool -- De esta forma cualquier mano sera valido
otro _ = True


{- 4 alguienSeCarteo/1, dada una lista de jugadores. Sabemos que alguien se carteó cuando hay alguna carta que se repite, ya sea en un mismo jugador o en distintos. -}

concatenar lista = foldl (++) [] lista

-- La idea es comparar listas de cartas: haskell permite comparar listas con listas usando == o /=
-- Dado una lista de jugadores, con map se obtienen todas las manos de los jugadores [lista de listas o lista de manos]
-- Para aplanar esa lista usamos concatenar. Luego se comparan ambas listas, siendo una sinRepetidos

alguienSeCarteo :: [Jugadores] -> Bool
alguienSeCarteo jugadores = sinRepetidos totalDeCartas /= totalDeCartas
    where totalDeCartas = (concatenar . map mano) jugadores


{- 5A Dada la siguiente lista de valores para los distintos juegos:
valores = [(par,1), (pierna,2), (color,3), (fullHouse,4), (poker,5), (otro, 0)]
Definir valor/1 que, dada una lista de cartas, nos indique el valor del mismo, que es el máximo valor entre los juegos que la lista de cartas cumple. -}

valores = [(esPar,1), (esPierna,2), (esColor,3), (esFullHouse,4), (esPoker,5), (otro, 0)]

-- Dada una lista de valores, con filter a cada tupla se usa el primer elemento (fst), la cual es una funcion que definimos previamente
-- Esa funcion ingresa como primer parametro o funcion de $ que recibe un listado de cartas (una mano)
-- Ese filter entonces devuelve los valores (o juegos ) que la mano cumple
-- Para saber el mayor juego maximoSegun recibe snd y esa lista de valores que cumplen
-- Tras ello, devuelve el mayor juego. Para saber el valor del juego, como es una tupla, utilizamos snd  

valor :: Mano -> Number
valor cartas = snd . maximoSegun snd . filter (($ cartas).fst) $ valores

{- 5B bebidaWinner/1, que dada una lista de jugadores nos devuelve la bebida de aquel jugador que tiene el juego de mayor valor, pero sin considerar a aquellos que tienen manos mal armadas. -}

-- Con filter y utilizando not.manoMalArmada, obtenemos una lista de jugadores sin considerar a aquellos con mano mal armada
-- maximoSegun recibe valor como f y utiliza la mano de cada jugador de la lista previamente obtenida
-- Esta funcion devuelve aquel jugador que tiene el mayor juego, y para conocer su bebida utilizamos bebidaPreferida

bebidaWinner :: [Jugadores] -> String
bebidaWinner jugadores = bebidaPreferida . maximoSegun (valor.mano) . filter (not.manoMalArmada) $ jugadores

