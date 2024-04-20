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

-- Issue 1
-- Elimino subtract y lo reemplazo por una suma, y ademas anioFundacion ciudad lo convierto en negativo
-- Es correcto asi?
valorCiudad :: Ciudad -> Number
valorCiudad ciudad | anioFundacion ciudad < 1800          =  (+1800) (- anioFundacion ciudad)
                   | atraccionesPrincipales ciudad == []  = costoDeVida ciudad *2
                   | otherwise                            = costoDeVida ciudad *3


-- Issue 2.1
-- Cambio de nombres a unos mas expresivos. Son adecuados?
esVocal :: Char -> Bool
esVocal letra = letra `elem` "aeiouAEIOU"

esUnaAtraccionCopada :: String -> Bool
esUnaAtraccionCopada (primeraLetra:_) = esVocal primeraLetra

tieneAtraccionesCopadas :: LaCiudadEs
tieneAtraccionesCopadas ciudad = any esUnaAtraccionCopada (atraccionesPrincipales ciudad)


-- Issue 2.2
aumentarPorcentaje :: Number -> Number -> Number
aumentarPorcentaje aumento costo = aumento * costo / 100 + costo

-- bajarCostodeVida ahora recibe una Ciudad y retorna un numero. Es correcto?
-- O es preferible no modificar la funcion y solo cambiar el nombre a "reducir porcentaje"?
bajarCostodeVida :: Ciudad -> Number 
bajarCostodeVida ciudad = aumentarPorcentaje (-10) (costoDeVida ciudad)

-- Cambio de nombres en la recursividad. Es más expresivo de esta forma?
quitarUltimaAtraccion :: [a] -> [a]
quitarUltimaAtraccion [] = []  -- caso base
quitarUltimaAtraccion [primeraAtraccion] = [] -- caso unitario
quitarUltimaAtraccion (primeraAtraccion : atracciones) = primeraAtraccion : quitarUltimaAtraccion atracciones  -- recursividad

invocarCrisis :: Ciudad -> Ciudad
invocarCrisis ciudad = ciudad {
                        atraccionesPrincipales = quitarUltimaAtraccion (atraccionesPrincipales ciudad),
                        costoDeVida            = bajarCostodeVida ciudad
                    }