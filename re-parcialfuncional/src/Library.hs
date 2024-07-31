module Library where
import PdePreludat
import ShowFunction

-- Punto 1
{- Generar dominio -}

data Edificio = Edificio {
    pisos :: [Piso], -- lista de pisos
    valorBaseXm2 :: Number,
    coeficienteDeRobustez :: Number
} deriving Show

data Departamento = Departamento {
    superficieEnm2 :: Number,
    porcentajeDeHabitabilidad :: Number
} deriving Show

type Piso = (Number, [Departamento]) -- lista de departamentos

cantidadDeDeptos = length . snd

-- Punto 2 
{- Conocimientos de edificios:
    a. Cheto: decimos que un edificio es cheto, cuando todos sus pisos tienen un único departamento.
    b. Pajarera: Cuando los pisos tienen al menos 6 departamentos cada uno.
    c. Pirámide: Cuando cada piso tiene menos departamentos que el piso inmediato inferior 
-}

cheto edificio = all ((==1) . cantidadDeDeptos) (pisos edificio)

pajarera edificio = all ((>=6) . cantidadDeDeptos) (pisos edificio)

piramide edificio = verificarPiramide (pisos edificio)

verificarPiramide   [] = False
verificarPiramide  [_] = True
verificarPiramide (p1:p2:ps) = cantidadDeDeptos p1 > cantidadDeDeptos p2 && verificarPiramide (p2:ps)


-- Punto 3
{- Conocer el precio del departamento más caro de un edificio, según su superficie y el valor base del metro cuadrado del edificio, multiplicado por el coeficiente de robustez del mismo.
-}

masCaro edificio = maximum . calcularPrecio edificio . obtenerDeptos $ pisos edificio

obtenerDeptos = concatMap snd
-- Al usar map se obtienen listas con listas de deptos -> [[Deptos]] lo cual genera un problema para calcularPrecio
-- Esto se soluciona con concatMap ya que aplica la funcion y luego concatena todos los resultados, generando una sola lista

calcularPrecio edificio deptos = map ((* coeficienteDeRobustez edificio) . (* valorBaseXm2 edificio) . superficieEnm2) deptos