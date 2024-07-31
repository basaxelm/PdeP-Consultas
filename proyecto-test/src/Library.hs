module Library where
import PdePreludat
import ShowFunction

-- dominio

data Ciudad = Ciudad {
    nombre :: String,
    añoFundacion :: Number,
    atraccionesPrincipales :: [String],
    costoDeVida :: Number
} deriving Show

baradero = Ciudad {
    nombre = "Baradero",
    añoFundacion = 1615,
    atraccionesPrincipales = ["Parque del Este", "Museo Alejando Barbich"],
    costoDeVida = 150
}

nullish = Ciudad {
    nombre = "Nullish",
    añoFundacion = 1800,
    atraccionesPrincipales = [],
    costoDeVida = 140
}

caletaOlivia = Ciudad {
    nombre = "Caleta Olivia",
    añoFundacion = 1901,
    atraccionesPrincipales = ["El Gorosito", "Faro Costanera"],
    costoDeVida = 120
}

maipu = Ciudad {
    nombre = "Maipu",
    añoFundacion = 1878,
    atraccionesPrincipales = ["Fortin Kakel"],
    costoDeVida = 115
}

azul = Ciudad {
    nombre = "Azul",
    añoFundacion = 1832,
    atraccionesPrincipales = ["Teatro Español", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
    costoDeVida = 190
}


-- Funciones
{- Punto 1
    Definir el valor de una ciudad, un número que se obtiene de la siguiente manera:
    a) Si fue fundada antes de 1800, su valor es 5 veces la diferencia entre 1800 y el año de fundación
    b) Si no tiene atracciones, su valor es el doble del costo de vida
    c) De lo contrario, será 3 veces el costo de vida de la ciudad
 -}

valorCiudad ciudad 
            | añoFundacion ciudad < 1800 = (*5) (1800 - añoFundacion ciudad)
            | null (atraccionesPrincipales ciudad) = costoDeVida ciudad * 2
            | otherwise = costoDeVida ciudad * 3


{- Punto 2.1
    Queremos saber si una ciudad tiene alguna atracción copada, esto es que la atracción comience con una vocal. Por ejemplo:"Acrópolis" es una atracción copada y "Golden Gate" no es copada
 -}

isVowel :: Char -> Bool
isVowel character = character `elem` "aeiouAEIOU"

verificarPrimeraLetra = isVowel . head 

tieneAtraccionesCopadas ciudad = any verificarPrimeraLetra $ atraccionesPrincipales ciudad


{- Punto 2.2
    Queremos saber si una ciudad es sobria, esto se da si todas las atracciones tienen más de x letras. El valor x tiene que poder configurarse.
 -}

verificarCantidadDeLetras cantidad lista = length lista > cantidad

ciudadSobria cantidad ciudad = all (verificarCantidadDeLetras cantidad) (atraccionesPrincipales ciudad)


{- Punto 2.3
    Queremos saber si una ciudad tiene un nombre raro, esto implica que tiene menos de 5 letras en su nombre. Recuerde que no puede definir funciones auxiliares.
 -}

tieneNombreRaro = (<5) . length . nombre 


{- Punto 3
    Queremos poder agregar una nueva atracción a la ciudad. Esto implica un esfuerzo de toda la comunidad en tiempo y dinero, lo que se traduce en un incremento del costo de vida de un 20%.
 -}

agregarNuevaAtraccion atraccion ciudad = ciudad {
                                        atraccionesPrincipales = atraccion : atraccionesPrincipales ciudad,
                                        costoDeVida = costoDeVida ciudad + costoDeVida ciudad * 0.2
                                    }


{- Punto 3.1
    Al atravesar una crisis, la ciudad baja un 10% su costo de vida y se debe cerrar la última atracción
 -}

crisis ciudad = ciudad {
    atraccionesPrincipales = init (atraccionesPrincipales ciudad),
    costoDeVida = costoDeVida ciudad - costoDeVida ciudad * 0.1
}


{- Punto 3.2
    Al remodelar una ciudad, incrementa su costo de vida un x% (valor que se quiere configurar) y le agrega el prefijo "New " al nombre.
 -}

remodelar valor ciudad = ciudad {
    nombre = "New" ++ " " ++ nombre ciudad,
    costoDeVida = costoDeVida ciudad + costoDeVida ciudad * (valor / 100)
} 


{- Punto 3.3
    Si la ciudad es sobria con atracciones de más de n letras (valor que se quiere configurar), aumenta el costo de vida un 10%, si no baja 3 puntos.
 -}

reevaluar valor ciudad | ciudadSobria valor ciudad = ciudad { costoDeVida = costoDeVida ciudad + costoDeVida ciudad * 0.1 }
                       | otherwise = ciudad { costoDeVida = costoDeVida ciudad - 3 }


{- Punto 5.1
    Queremos modelar un año, donde definamos
    . el número que le corresponde
    . una serie de eventos que se produjeron
    También queremos reflejar el paso de un año para una ciudad, es decir, que los eventos afecten el estado final en el que queda una ciudad.
 -}

type Evento = Ciudad -> Ciudad
data Anio = Anio {
    anio :: Number,
    eventos :: [Evento]
} deriving Show

dosmilveintitres = Anio {
    anio = 2023,
    eventos = [crisis, agregarNuevaAtraccion "Parque", remodelar 10, remodelar 20]
}

dosmilveintidos = Anio {
    anio = 2022,
    eventos = [crisis, remodelar 5, reevaluar 7]
}

dosmilveintiuno = Anio {
    anio = 2021,
    eventos = [crisis, agregarNuevaAtraccion "Playa"]
}

dosmilquince = Anio {
    anio = 2015,
    eventos = []
}

aplicarEventos ciudad eventos = foldl (\ciudad evento -> evento ciudad) ciudad eventos

pasoDelAnio anio ciudad = aplicarEventos ciudad (eventos anio)
-- para foldl la funcion recibe primero la seed y luego el elemento de la lista, para acumularlo (left)

-- otra opcion puede ser con foldr -> foldr ($) ciudad (eventos anio)
-- para foldr la funcion primero recibe el elemento de la lista y luego la seed, para acumularlo (right)


{- Punto 5.2
    Implementar una función que reciba una ciudad, un criterio de comparación y un evento, de manera que nos diga si la ciudad tras el evento subió respecto a ese criterio
 -}

segunCostoDeVida = costoDeVida 

segunCantidadDeAtracciones = length . atraccionesPrincipales 

algoMejor ciudad criterio evento = criterio (evento ciudad) > criterio ciudad


{- Punto 5.3
    Para un año, queremos aplicar sobre una ciudad solo los eventos que hagan que el costo de vida suba. Debe quedar como resultado la ciudad afectada con dichos eventos.
 -}

soloSubeCostoDeVida anio ciudad = aplicarEventos ciudad . filter (algoMejor ciudad segunCostoDeVida) $ eventos anio


{- Punto 5.4
    Para un año, queremos aplicar solo los eventos que hagan que el costo de vida baje. Debe quedar como resultado la ciudad afectada con dichos eventos.
 -}

algoPeor ciudad criterio evento = criterio (evento ciudad) < criterio ciudad

soloBajaCostoDeVida anio ciudad = aplicarEventos ciudad . filter (algoPeor ciudad segunCostoDeVida) $ eventos anio


{- Punto 5.5
    Para un año, queremos aplicar solo los eventos que hagan que el valor suba. Debe quedar como resultado la ciudad afectada con dichos eventos.
 -}

-- Utiliza la funcion soloSubeCostoDeVida del punto 5.3


{- Punto 6.1
    Dado un año y una ciudad, queremos saber si los eventos están ordenados en forma correcta, esto implica que el costo de vida al aplicar cada evento se va incrementando respecto al anterior evento. Debe haber al menos un evento para dicho año.
 -}

segunEventos ciudad evento = costoDeVida (evento ciudad)

segunCiudades evento ciudad = costoDeVida (evento ciudad)

segunAnios ciudad anio = costoDeVida (pasoDelAnio anio ciudad)

verificarOrden _ _ []  = False
verificarOrden _ _ [x] = True
verificarOrden segun algo (x:y:ys) = segun algo x < segun algo y && verificarOrden segun algo (y:ys)

eventosOrdenados anio ciudad = verificarOrden segunEventos ciudad (eventos anio)

{- Punto 6.2
    Dado un evento y una lista de ciudades, queremos saber si esa lista está ordenada. Esto implica que el costo de vida al aplicar el evento sobre cada una de las ciudades queda en orden creciente. Debe haber al menos una ciudad en la lista.
 -}

ciudadesOrdenadas evento ciudades = verificarOrden segunCiudades evento ciudades 


{- Punto 6.3
    Dada una lista de años y una ciudad, queremos saber si el costo de vida al aplicar todos los eventos de cada año sobre esa ciudad termina generando una serie de costos de vida ascendentes (de menor a mayor). Debe haber al menos un año en la lista.
 -}

aniosOrdenados ciudad anios = verificarOrden segunAnios ciudad anios