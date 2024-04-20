module Library where
import PdePreludat
import ShowFunction

type LaCiudadEs = Ciudad -> Bool

data Ciudad = Ciudad{
        nombre :: String,
        anioFundacion :: Number,
        atraccionesPrincipales :: [String],
        costoDeVida :: Number
} deriving Show

baradero = Ciudad{
    nombre = "Baradero",
    anioFundacion = 1615,
    atraccionesPrincipales = ["Parque del Este", "Museo Alejandro Barbich"],
    costoDeVida = 150
}
nullish = Ciudad{
    nombre = "Nullish",
    anioFundacion = 1800,
    atraccionesPrincipales = [],
    costoDeVida = 140 
}
caletaOlivia = Ciudad{
    nombre = "Caleta Olivia",
    anioFundacion = 1901,
    atraccionesPrincipales = ["El Gorosito","Faro Costanera"],
    costoDeVida = 120
} 

azul = Ciudad{
    nombre = "Azul",
    anioFundacion = 1832,
    atraccionesPrincipales = ["Teatro Español", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
    costoDeVida = 190 
}

maipu = Ciudad{
  nombre = "Maipu",
  anioFundacion = 1878,
  atraccionesPrincipales =["Fortin Kakel"],
  costoDeVida = 115
}

--Funciones Punto 1

-- Elimino subtract y lo reemplazo por una suma, y ademas anioFundacion ciudad lo convierto en negativo
valorCiudad :: Ciudad -> Number
valorCiudad ciudad | anioFundacion ciudad < 1800          =  (+1800) (- anioFundacion ciudad)
                   | null (atraccionesPrincipales ciudad) = costoDeVida ciudad *2
                   | otherwise                           = costoDeVida ciudad *3

-- 