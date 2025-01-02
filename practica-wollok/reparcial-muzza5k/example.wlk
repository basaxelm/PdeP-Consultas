import exceptions.*

// ------------ UTILS ------------
object utils {
  /* Example:
    const list = createPairs(["one", "two", "three"])
    list ==> Answers ["one" -> "two", "two" -> "three"]  
    
    list.get(0).x() ==> Answers "one"
    list.get(0).y() ==> Answers "two"
    list.get(1).x() ==> Answers "two"
    list.get(1).y() ==> Answers "three"
  */
  method createPairs(list) =
    (0..(list.size()-2)).map{ pos => new Pair(x = list.get(pos), y = list.get(pos+1)) }
}


/* Punto 1 */
// Pizzas
class Pizza {
  const porciones = 8
  const ingredientes 

  method costo() = self.calcularCosto() * 100

  method calcularCosto() = ingredientes.sum { ingrediente => ingrediente.size()}

  method agregar(ingrediente) {
    ingredientes.add(ingrediente)
  }

  method contiene(ingrediente) =
    ingredientes.contains(ingrediente)
}

class PizzaChica inherits Pizza (porciones = 4) {
  
  override method costo() = super() * 0.75
}

class PizzaCompuesta {
  const porciones
  const pizzas

  method costo() = self.pizzaMasCostosa().first().costo()

  method pizzaMasCostosa() = pizzas.sortedBy { p1, p2 => p1.costo() > p2.costo() } // Mas costosa

  method esValida() = pizzas.size() <= porciones

  method agregar(ingrediente) {
    pizzas.forEach { pizza => pizza.agregar(ingrediente) }
  }
}


// Pizzerias
class Pizzeria {
  const property ingredienteEspecial 
  const property pizzaPredilecta 
  const property porcionesLimite
  const costoBase
  var property estilo = normal

  method agregar(ingrediente, pizza) {
    pizza.agregar(ingrediente)
  }

  method crearEntrega(pedido){
    const precio = self.precio(pedido)
    const entrega = new Entrega( pedidoCliente = pedido, 
                                 entregaCliente = [], 
                                 precioPedido = precio,
                                 precioEntrega = 0)

    const pedidoListo = estilo.preparar(pedido, self)
    self.entregar(pedidoListo, entrega)
    self.agregarPrecio(pedidoListo, entrega)

    return entrega
  }

  method entregar(pedidoListo, entrega) = 
    pedidoListo.forEach { pizza => entrega.entregaCliente().add(pizza) }

  method agregarPrecio(pedidoListo, entrega) {
    const precio = self.precio(pedidoListo)

    entrega.precioEntrega(precio)
  }

  method combinar(pizza1, pizza2) {
    const pizzas = [pizza1, pizza2]
    const pizzaCombinada = new PizzaCompuesta( porciones = 2, pizzas = pizzas )

    return pizzaCombinada
  }

  /* Punto 2 */
  method precioFinal(pizza) = (pizza.costo() + costoBase) * indice.factorChetez(self)

  method precio(pedido) = pedido.sum { pizza => self.precioFinal(pizza) }
}

object indice { // No sabemos como se obtiene el factor de chetez

  method factorChetez(pizzeria) = 1 
}

/* Punto 3 con estilos que pueden cambiar durante su ciclo de vida */

object normal {

  method preparar(pedido, pizzeria) {
    return pedido
  }
}

object ingredienteExtra {

  method preparar(pedido, pizzeria) {
    const especial = pizzeria.ingredienteEspecial()

    return pedido.forEach { pizza => pizzeria.agregar(especial, pizza) } 
  }
}

object resumen {

  method preparar(pedido, pizzeria) {
    const porciones = pizzeria.porcionesLimite()
    const pizzaCombinada = new PizzaCompuesta( porciones = porciones, pizzas = pedido)

    if(not pizzaCombinada.esValida())
      throw new PizzaCompuestaNoValidaException (message = "La cantidad de porciones no es valida")
    else
      return pizzaCombinada
  }
}

object laPreferida {

  method preparar(pedido, pizzeria) {
    const pizzaPredilecta = pizzeria.pizzaPredilecta()
    const pizzasCombinadas = pedido.map { pizza => pizzeria.combinar(pizzaPredilecta, pizza) }

    return pizzasCombinadas
  }

}

object laCombineta {

  method preparar(pedido, pizzeria) {
    const paresPizzas = utils.createPairs(pedido)
    const pizzasCombinadas = paresPizzas.map { pizza1, pizza2 => pizzeria.combinar(pizza1, pizza2) }

    return pizzasCombinadas
  }
}


// Clientes
class Cliente {
  var nivelHumor          // -> de 1 a 10
  var entregaRecibida      // -> apunta a una entrega
  const property pedido   // -> Coleccion de pizzas

  method modificarHumor(indice) {
    nivelHumor += indice
  }

  method realizarPedido(pizzeria){
    entregaRecibida = pizzeria.crearEntrega(pedido)
  }

  method recibir(entrega){
    entregaRecibida = entrega
  }

  method pedidosSonIguales() = 
    pedido.all { pizza => entregaRecibida.entregaCliente().contains(pizza) }

  method pagaMasYRecibeMenos() = 
    entregaRecibida.precioEntrega() < entregaRecibida.precioPedido()

  method entregaContiene(ingrediente) =
    entregaRecibida.entregaCliente().any { pizza => pizza.contiene(ingrediente) }

}

class SuperExigente inherits Cliente {

  override method realizarPedido(pizzeria) {
    super(pizzeria)
    if(not self.pedidosSonIguales())
      self.modificarHumor(-1)
    else 
      self.modificarHumor(1)
  }
}

class Humilde inherits Cliente {

  override method realizarPedido(pizzeria) {
    super(pizzeria)
    if(self.pagaMasYRecibeMenos())
      self.modificarHumor(-1)
    else 
      self.modificarHumor(1)
  }
}

class Manioso inherits Cliente {
  const ingredienteInaceptable

  override method realizarPedido(pizzeria) {
    super(pizzeria)
    if(self.entregaContiene(ingredienteInaceptable))
      self.modificarHumor(-1)
    else 
      self.modificarHumor(1)
  }
}


/* Punto 3 */
// Entregas

class Entrega {
  const property pedidoCliente
  const property entregaCliente
  var property precioPedido 
  var property precioEntrega

}

