object joaquin {
  const habilidadBase = 20
  const extra = 5
  var grupo = "pimpinela"

  method habilidad() = if (self.estaEnUnGrupo()) habilidadBase + extra else habilidadBase

  method estaEnUnGrupo() = not grupo.isEmpty()

  method abandonarGrupo() {
    grupo = ""
  }
}

object lucia {
  const habilidadBase = 70
  const extra = 20
  var grupo = "pimpinela"

  method habilidad() = if (self.estaEnUnGrupo()) habilidadBase - extra else habilidadBase

  /* isEmpty interpreta una cadena de chars como una lista, por lo que puede usarse */
  method estaEnUnGrupo() = not grupo.isEmpty()

  method abandonarGrupo() {
    grupo = ""
  }
}

object luisAlberto {
  var guitarra = fender

  method habilidad () = (guitarra.valor() * 8).min(100)

  /* Es necesario agregar un setter porque puede cambiar la guitarra */
  method guitarra(nuevaGuitarra) {
    guitarra = nuevaGuitarra
  } 
}

object fender {
  method valor() = 10 
} 

object gibson {
  var estaSana = true
  method valor() = if (estaSana) 15 else 5  

  /* Simplemente creamos un metodo que 'rompe' la gibson y cambia el estado de la guitarra */
  method romper() {
    estaSana = false
  }  
}

/* object bardo {

  method componer(duracion, unaLetra) = 
    object {
      const letra = unaLetra
      method duracion() = duracion
      method contieneFrase(frase) = letra.toLowerCase()
    }

} */