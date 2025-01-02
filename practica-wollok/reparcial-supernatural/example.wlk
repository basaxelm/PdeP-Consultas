import exceptions.*

/* Punto 1 */
// Cazadores y Monstruos
class Cazador {
  const monstruosCazados
  const property objetos
  var property nivelDestreza

  method atrapar(monstruo) {
    if(not monstruo.puedeSerAtrapado(self))
      monstruo.atacar(self)
    else
      monstruosCazados.add(monstruo)
  }

  method quitarObjetos() {
    objetos.clear()
  }

  method modificarDestreza(valor) {
    nivelDestreza = (nivelDestreza + valor).max(0)
  }

  method quitarUltimoMonstruo() {
    const ultimo = monstruosCazados.last()

    monstruosCazados.remove(ultimo)
  }

  method quitarUltimoObjeto() {
    const ultimo = objetos.last()

    objetos.remove(ultimo)
  }

  method agregar(objeto) {
    objetos.add(objeto)
  }

  method cantidadMonstruos() = monstruosCazados.size()

  method elMasJodido() = 
    monstruosCazados.sortedBy { m1 => m1.nivelDeJodidez() }.first().nivelDeJodidez()

  method monstruosFaciles() =
    monstruosCazados.filter { monstruo => monstruo.nivelDeJodidez() == 1 }.size()
}


class Monstruo {
  const requeridos            // requeridos para cazar al monstruo
  const requeridosPersonales  // requeridos que se relacionan con la persona que fue
     
  method puedeSerAtrapado(cazador) =
    cazador.objetos().all { objeto => self.todosLosRequeridos().contains(objeto) }

  method todosLosRequeridos() = requeridos + requeridosPersonales

  method atacar(cazador) { } // Sin efecto

  method nivelDeJodidez() = self.todosLosRequeridos().size()

}

// Especies de Monstruos
class Banshees inherits Monstruo {

  override method atacar(cazador) {
    cazador.quitarObjetos()
  }
}

class Curupi inherits Monstruo {

  override method atacar(cazador) {
    const destreza = cazador.nivelDestreza() / 2

    cazador.modificarDestreza(- destreza)
  }
}

class LuzMala inherits Monstruo {

  override method atacar(cazador) {
    const puntos = cazador.objetos().size()

    cazador.modificarDestreza(- puntos)
  }
}

class Djinn inherits Monstruo {

  override method atacar(cazador) {
    if(not cazador.monstruosCazados().isEmpty())
      cazador.modificarDestreza(1)
      cazador.quitarUltimoMonstruo()
  }
}


/* Punto 2 */
// Casos

class Crimen {
  const pista

  method investigar(cazador){
    cazador.agregar(pista)
  }
}

object trampa {

  method investigar(cazador) {
    cazador.quitarUltimoObjeto()
  }
}

class Avistaje {
  const destrezaExtra

  method investigar(cazador) {
    cazador.modificarDestreza(destrezaExtra)
  }
}


/* Punto 3 */

class Concurso {
  const criterio
  const participantes = #{} // Conjunto de participantes
  const condicionParaParticipar

  method podio() = participantes.sortedBy(criterio).take(3) // take retorna una lista de los 3 primeros elementos

  method inscribir(cazador) {
    if(not condicionParaParticipar.cumple(cazador))
      throw new NoPuedeParticiparException ( message = "El cazador no cumple los requisitos" )
    else
      participantes.add(cazador)
  }

}

// Criterios

const segunMasMonstruos  = 
  { p1, p2 => p1.cantidadMonstruos() > p2.cantidadMonstruos() }

const segunElMasJodido   = 
  { p1, p2 => p1.elMasJodido() > p2.elMasJodido() }

const segunElMasHolgazan = 
  { p1, p2 => p1.monstruosFaciles() > p2.monstruosFaciles() }









