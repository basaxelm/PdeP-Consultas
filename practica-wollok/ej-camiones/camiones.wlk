import exceptions.*

class Camion {
  const property carga = []
  const cargaMaxima
  var property estado = disponibleParaLaCarga

/* Punto 1 y 3*/
  method cargar(coso) {
    if(not self.puedeAceptar(coso)) // fail fast
      throw new NoSePuedeCargarException (message = "El peso del objeto supera la carga maxima")
    carga.add(coso)
  }

/* Punto 2 -> Falta agregar estado de carga */
  method puedeAceptar(coso) = self.noSuperaLaCargaMaxima(coso) && estado.puedeAceptar(coso, self) 

  method noSuperaLaCargaMaxima(coso) = coso.peso() + self.pesoCargado() <= cargaMaxima 

  method pesoCargado() = carga.sum { coso => coso.peso() }

/* Punto 5 -> Falta agregar estado de carga */ 
  method estaListoParaPartir() = self.estaCargadoAl(0.75) && estado.puedePartir()

  method estaCargadoAl(porcentaje) = self.pesoCargado() >= cargaMaxima * porcentaje 

}

class Estado {

  method puedeAceptar(coso, camion) = false

  method puedePartir() = false

  method entraEnReparacion(camion) {
    camion.estado(enReparacion)
  }

  method saleDeReparacion(camion) {
    camion.estado(disponibleParaLaCarga)
  }

  method saleDeViaje(camion) {
    camion.estado(enViaje)
  }

  method vuelveDeViaje(camion) {
    camion.estado(disponibleParaLaCarga)
  }   
}

object disponibleParaLaCarga inherits Estado {

  override method puedeAceptar(coso, camion) = true

  override method puedePartir() = true

  override method saleDeReparacion(camion) {
    throw new ElCamionNoEstaEnReparacionException ( message = "El camion no entro a reparacion" )  
  }

  override method vuelveDeViaje(camion) {
    throw new ElCamionNoSalioDeViajeException ( message = "El camion no salio de viaje" )
  }
}

object enReparacion inherits Estado {
  
  override method entraEnReparacion(camion) {
    throw new ElCamionEstaEnReparacionException ( message = "El camion ya esta en reparacion" )
  }
  
  override method saleDeViaje(camion) {
    throw new ElCamionEstaEnReparacionException ( message = "El camion no puede salir de viaje" )
  }

  override method vuelveDeViaje(camion) {
    throw new ElCamionEstaEnReparacionException ( message = "El camion no salio de viaje" )
  }
}

object enViaje inherits Estado {
  
  override method entraEnReparacion (camion) {
    throw new ElCamionSalioDeViajeException ( message = "El camion salio de viaje" )
  }

  override method saleDeReparacion (camion) {
    throw new ElCamionSalioDeViajeException ( message = "El camion no entro a reparacion" )
  }

  override method saleDeViaje (camion) {
    throw new ElCamionSalioDeViajeException ( message = "El camion ya esta en viaje" )
  }
}
