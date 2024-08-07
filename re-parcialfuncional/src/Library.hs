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


-- Punto 4
{- Remodelaciones... como somos cool, las nombramos en inglés:
    a. Merge: Dada una lista de departamentos, nos devuelve uno nuevo “unificado”, con la superficie total de los anteriores y la habitabilidad promedio.
    b. Split: Dado una cantidad y un departamento, nos da una lista de departamentos resultantes de dividir el anterior en esa cantidad, con la superficie homogénea y la misma habitabilidad.
-}

merge deptos = Departamento { 
                    superficieEnm2 = superficieTotal deptos,
                    porcentajeDeHabitabilidad = habitabilidadPromedio deptos
                }

superficieTotal deptos = sum . map superficieEnm2 $ deptos
habitabilidadPromedio deptos = (/ length deptos) . sum . map porcentajeDeHabitabilidad $ deptos


split cantidad depto = replicate cantidad splitDeptos
            where splitDeptos = Departamento {
                    superficieEnm2 = superficieEnm2 depto / cantidad,
                    porcentajeDeHabitabilidad = porcentajeDeHabitabilidad depto
            }


-- Punto 5
{- Las catástrofes están a la orden día en Ciudad Batracia y afectan a los edificios, por lo que no podemos omitir sus efectos en nuestro modelo:
    a. Incendio: Se produce desde un piso en particular, afectando a este y todos los pisos superiores. Reduce la habitabilidad de los departamentos afectados en 30 puntos porcentuales y la robustez del edificio se reduce a la mitad.
    b. Plaga: La plaga afecta a un piso del edificio dado por su número y reduce la habitabilidad de sus departamentos en una cantidad de puntos porcentuales variable.
    c. Terremoto: Reduce la robustez del edificio en un valor indicado.
-}

-- Funcion auxiliar
cambiarElemento posicion elemento lista = take (posicion - 1) lista ++ [ elemento ] ++ drop posicion lista

-- a)
incendio numPiso edificio = edificio {
                        pisos = afectarXIncendio numPiso (pisos edificio),
                        valorBaseXm2 = valorBaseXm2 edificio,
                        coeficienteDeRobustez = coeficienteDeRobustez edificio / 2
                    }

afectarXIncendio numPiso pisos 
        | numPiso <= length pisos = afectarXIncendio (numPiso + 1) . cambiarElemento numPiso (afectarDeptos 30 (pisos !! numPiso)) $ pisos
        | otherwise = pisos

afectarDeptos valor (piso, deptos) = (piso, map (reducirHabitabilidad valor) deptos)
        where reducirHabitabilidad valor depto = depto { porcentajeDeHabitabilidad = porcentajeDeHabitabilidad depto - valor}

--b)
plaga valor numPiso edificio = edificio { pisos = afectarXPlaga valor numPiso (pisos edificio) }

afectarXPlaga valor numPiso pisos = cambiarElemento numPiso (afectarDeptos valor (pisos !! numPiso)) pisos

--c)
terremoto valor edificio = edificio { coeficienteDeRobustez = coeficienteDeRobustez edificio - valor}


-- Punto 6
{- De la mano de las catástrofes, llegan los arreglos o mejoras al edificio:
    a. Ampliación: se realiza la construcción de un nuevo piso con una determinada cantidad de departamentos y de metros, que se reparten equitativamente entre los departamentos. El piso se agrega arriba, porque las máquinas para levantar los N pisos superiores de un edificio las tenemos descompuestas y no podemos meterlo en el medio. Al ser nuevo, su habitabilidad es de 100.
    b. Fumigación: A cada departamento que tiene habitabilidad menor a 60%, les sube en 20 puntos porcentuales.
    c. MergeEdificio: Debe aplicar un merge sobre un número de piso dado de un edificio.
    d. SplitEdificio: Recibe una cantidad de nuevos departamentos y el número de piso donde debe hacer un split sobre el último departamento
-}

mejorar edificio nuevosPisos = edificio { pisos = nuevosPisos}

--a)
ampliacion cantidad superficie edificio = mejorar edificio (pisos edificio ++ [agregarNuevoPiso cantidad superficie numPiso])
            where numPiso = length (pisos edificio)

agregarNuevoPiso cantidad superficie numPiso = (numPiso + 1 , split cantidad . obtenerDeptoBase $ superficie)
            where obtenerDeptoBase superficie = Departamento {
                                        superficieEnm2 = superficie,
                                        porcentajeDeHabitabilidad = 100
                                    }


--b)
fumigacion edificio = mejorar edificio (map modificarDeptos (pisos edificio))

modificarDeptos (piso, deptos) = (piso, map aumentarHabitabilidad deptos)
            where aumentarHabitabilidad depto 
                            | porcentajeDeHabitabilidad depto < 60 = depto { porcentajeDeHabitabilidad = porcentajeDeHabitabilidad depto + 20}
                            | otherwise = depto