module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
--Punto 1
  describe "Utilización de valorCiudad/1" $ do
    it "Si el año de fundacion es antes de 1800, entonces, se incrementa 5 veces el valor" $ do
      valorCiudad baradero `shouldBe` 925
    it "Si, no tiene atracciones, el valor se duplica" $ do
      valorCiudad nullish `shouldBe` 280 
    it "Sino el valor se triplica " $ do
      valorCiudad caletaOlivia `shouldBe` 360 


--Punto 2.1
--Tiene Atracciones Copadas?
  describe "Utilización de tieneAtraccionesCopadas" $ do
    it "La ciudad Baradero no tiene atracciones que comiencen con una vocal, por lo que no es copada" $ do
      tieneAtraccionesCopadas baradero  `shouldBe` False
    it "La ciudad Nullish no tiene atracciones siquiera, por lo que no es copada" $ do
      tieneAtraccionesCopadas nullish  `shouldBe` False
    it "La ciudad Caleta Olivia tiene una atraccion que comienza con una vocal, por lo que es copada" $ do
      tieneAtraccionesCopadas caletaOlivia  `shouldBe` True


--Punto 2.2
--Ciudad sobria
  describe "Utilización de ciudadSobria/2" $ do
    it "La ciudad Baradero tiene atracciones con 15 y 24 letras que son mas de 14 por lo tanto es ciudad sobria" $ do
      ciudadSobria 14 baradero  `shouldBe` True 
    it "La ciudad Baradero tiene atracciones con 15 y 24 letras una exactamente igual a 15 por lo tanto no es ciudad sobria" $ do
      ciudadSobria 15 baradero  `shouldBe` False 
    it "La ciudad Nullish no tiene atracciones por lo tanto no es ciudad sobria" $ do
      ciudadSobria 5 nullish  `shouldBe` True


--Punto 2.3
-- Ciudad de Nombre Raro
  describe "Utilización de ciudadDenombreRaro/1" $ do
    it "La ciudad Azul tiene 4 letras por lo tanto tiene nombre raro" $ do
      tieneNombreRaro azul `shouldBe` True 
    it "La ciudad Maipu tiene 5 letras por lo tanto no tiene nombre raro" $ do
      tieneNombreRaro maipu `shouldBe` False 


--Punto 3      
  describe "Utilización de agregarNuevaAtraccion/2" $ do
    it "La ciudad debe tener 4 atracciones y su costo de vida debe quedar en 228" $ do
       atraccionesPrincipales (agregarNuevaAtraccion "Balneario Municipal Alte. Guillermo Brown" azul) `shouldBe` ["Balneario Municipal Alte. Guillermo Brown" ,"Teatro Español", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"]

--Punto 3.1
--Invocar Crisis
  describe "Utilización de invocarCrisis" $ do
    it "Si se invoca una crisis sobre azul debe bajar un 10% su costo de vida" $ do
        costoDeVida(crisis azul) `shouldBe` 171
    it "Si se invoca una crisis sobre azul debe cerrar la ultima atraccion" $ do
        atraccionesPrincipales(crisis azul)
        `shouldBe` ["Teatro Español", "Parque Municipal Sarmiento"]

--Punto 3.2                                                                                       
--Remodelar ciudad 
  describe "Utilización de remodelarCiudad/2" $ do
    it "La ciudad debe tener quedar con un nombrede New Azul y su costo de vide debe aumentar a 285" $ do
       nombre (remodelar 50 azul) `shouldBe`  "New Azul" 
       costoDeVida(remodelar 50 azul) `shouldBe`   285 

--Punto 3.3        
-- Reevaluacion
  describe "Utilización dereevaluandoElValor/2" $ do
    it "Si la ciudad Azul no es sombria, baja a un coste de vida de 187" $ do
      costoDeVida (reevaluar 14 azul) `shouldBe` 187
    it "Si la ciudad Azul es sombria, aumenta su costo de vida a 209" $ do
      costoDeVida (reevaluar 13 azul) `shouldBe` 209 


--Punto 5.1 
--Los años pasan
  describe "Utilizacion de aplicarPasoDelAnio/2" $ do
    it "Debe quedar con el nombre  New Azul, un costo de vida de 197.505 y perder la ultima atraccion" $ do
      nombre (pasoDelAnio dosmilveintidos azul) `shouldBe` "New Azul"
      costoDeVida (pasoDelAnio dosmilveintidos azul) `shouldBe` 197.505
      atraccionesPrincipales (pasoDelAnio dosmilveintidos azul) `shouldBe` ["Teatro Español", "Parque Municipal Sarmiento"]

  describe "Utilizacion de aplicarPasoDelAnio/2" $ do
    it "Debe quedar con el mismo  costo de vida " $ do
      costoDeVida (pasoDelAnio dosmilquince azul) `shouldBe` costoDeVida azul


--Punto 5.2 
--Algo Mejor
  describe "Utilizacion de esAlgoMejor/3" $ do
    it "Para la ciudad azul, el criterio costo de vida y el evento crisis, la ciudad no subio respecto a ese criterio " $ do
      algoMejor azul segunCostoDeVida crisis `shouldBe` False
    it "Para la ciudad azul, el criterio costo de vida y el evento agregar atraccion 'Monasterio Trapense', la ciudad subio respecto a ese criterio " $ do
      algoMejor azul segunCostoDeVida (agregarNuevaAtraccion "Monasterio Trapense") `shouldBe` True
    it "Para la ciudad azul, el criterio cantidad de atracciones y el evento agregar atraccion 'Monasterio Trapense', la ciudad subio respecto a ese criterio " $ do
      algoMejor azul segunCantidadDeAtracciones (agregarNuevaAtraccion "Monasterio Trapense") `shouldBe` True


--Punto 5.3 
--Costo de vida que suba
  describe "Utilizacion de soloSubirCostoDeVida/2" $ do
    it "Para el año 2022 y la ciudad azul, se deben aplicar solo los eventos que hagan que el costo de vida suba" $ do
      nombre (soloSubeCostoDeVida dosmilveintidos azul) `shouldBe` "New Azul"
      costoDeVida (soloSubeCostoDeVida dosmilveintidos azul) `shouldBe` 219.45


--Punto 5.4 
--Costo de vida que baje 
  describe "Utilizacion de soloBajarCostoDeVida/2" $ do
    it "Debe quedar con el mismo nombre Azul, un costo de vida de 171 y perder la ultima atraccion" $ do
      nombre (soloBajaCostoDeVida dosmilveintidos azul) `shouldBe` "Azul"
      costoDeVida (soloBajaCostoDeVida dosmilveintidos azul) `shouldBe` 171
      atraccionesPrincipales (soloBajaCostoDeVida dosmilveintidos azul) `shouldBe` ["Teatro Español", "Parque Municipal Sarmiento"]


--Punto 5.5 
--sube el valor
  describe "Utilización de soloSubirValor/2" $ do
    it "La ciudad debe tener quedar con el nombrede New Nullish  y su costo de vide debe quedar en 161.7" $ do
      nombre (soloSubeCostoDeVida dosmilveintidos nullish) `shouldBe`  "New Nullish" 
      costoDeVida (soloSubeCostoDeVida dosmilveintidos nullish) `shouldBe`  161.7


--Punto 6.1
--Eventos Ordenados
  describe "Utilizacion de losEventosEstanOrdenados/2" $ do
    it "Para el año 2022 y la ciudad azul, los eventos estan ordenados de forma correcta" $ do
      eventosOrdenados dosmilveintidos azul `shouldBe` True
    it "Para el año 2023 y la ciudad azul, los eventos no estan ordenados de forma correcta" $ do
      eventosOrdenados dosmilveintitres azul `shouldBe` False

--Punto 6.2
--Ciudades Ordenadas
  describe "Utilización de lasCiudadesEstanOrdenadas/2" $ do
    it "Al aplicar el evento remodelarCiudad 10 la lista de ciudades debe quedar en orden creciente segun costo de vida" $ do
      ciudadesOrdenadas (remodelar 10) [caletaOlivia,nullish,baradero,azul] `shouldBe` True
  describe "Utilización de estaOrdenadaSegunCostoDeVida/2" $ do
    it "Al aplicar el evento remodelarCiudad 10 la lista de ciudades no queda en orden creciente segun costo de vida" $ do
      ciudadesOrdenadas (remodelar 10) [caletaOlivia,azul,baradero] `shouldBe` False 
         
--Punto 6.3
--Anios Ordenados
  describe "Utilización de losAniosEstanOrdenados/2" $ do
    it "Que los años 2021, 2022 y 2023 estén ordenados para Baradero da false" $ do
      aniosOrdenados baradero [dosmilveintiuno,dosmilveintidos,dosmilveintitres] `shouldBe` False 
    it "Que los años 2022, 2021 y 2023 estén ordenados para Baradero, de True, porque, al aplicar los años en ese orden va subiendo el costo de vida" $ do
      aniosOrdenados baradero [dosmilveintidos,dosmilveintiuno,dosmilveintitres] `shouldBe` True 