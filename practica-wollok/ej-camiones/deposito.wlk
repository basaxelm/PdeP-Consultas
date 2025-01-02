import exceptions.*

class Deposito {
  const camiones

  /* Punto 6 */
  method cargaTotal() = camiones.sum { camion => camion.pesoCargado() }

  /* Punto 7 */
  method obtenerCarga(camion) = 
    if (not self.estaEnElDeposito(camion))
        throw new ElCamionNoEstaEnElDepositoException (message = "No se encontro el camion")
    else
        camion.carga()

  method estaEnElDeposito(camion) = camiones.contains(camion)

}