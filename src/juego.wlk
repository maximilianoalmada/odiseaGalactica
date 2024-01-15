import wollok.game.*
import consola.*
import nivel1.*
import nivel2.*
import nivel3.*
import logicaNiveles.*


class Disparos  {
	var property position

	method image() = "disparo.png"
	
	method moverRight(objeto, number) {
    	if (game.hasVisual(self)) {
        	objeto.position(objeto.position().right(number))
            self.verificarColision(nivel1.naveEnemiga1())
            self.verificarColision(nivel1.naveEnemiga2())
            self.verificarColision(nivel1.naveEnemiga3())
        }
    }

    method verificarColision(enemigo) {
        if (self.position() == enemigo.position()) {
            enemigo.recibirDisparo(1)
            game.removeTickEvent("mover disparo")
            game.schedule(15,{game.removeVisual(self)})
            
        }
    }
	
    method ataqueDisparo() {
        if (game.hasVisual(self)) {
            game.onTick(100, "mover disparo", { => if (game.hasVisual(self)) { self.moverRight(self, 1) }})
        }
    }
	
	method agregarDisparo() {
		game.addVisual(self)
		self.ataqueDisparo()
	}
	
	method teChoco(algo) {}

}

object naveInicial {
	const perdiste = game.sound("perdiste.mp3")
	var property image = "naveDerecha.png"
	var position = game.origin()	
	var property vida = 3
	var property nafta = 200
	var property balas = 16
	var property objetosRecogidos = 0
	var property puedeDisparar=true
		
	method image(){
		if (vida == 0) {return "explosion.png"}
		else{return image}
		}
		
	method subir() {
		position = position.up(1)
		self.menosNafta(5)
	}
	
	method bajar() {
		position = position.down(1)
		self.menosNafta(5)
	}
	
	method izquierda() {
		position = position.left(1)
		self.menosNafta(5)
	}
	
	method derecha() {
		position = position.right(1)
		self.menosNafta(5)
	}
	
	method disparar(){
		const disparo = new Disparos(position = game.at(self.position().x()+ 1, self.position().y()))
		if (balas >= 1 and puedeDisparar){
			disparoNave.sonar()
			disparo.agregarDisparo()
		balas -= 1
		puedeDisparar=false
		game.schedule(450,{puedeDisparar=true})
		}
	}
	
	method recogerPieza(pieza) {
		objetosRecogidos += 1
		game.removeVisual(pieza)
	}	
	method position() = position
	
	// Comprobar movimientos
	
	method tieneNaftaSuficiente() = self.nafta() >= 5
	
	method puedeMoverArriba() = ((self.position().y() <= 12) and self.tieneNaftaSuficiente())
	
	method puedeMoverAbajo() = ((self.position().y() > 0) and self.tieneNaftaSuficiente())
	
	method puedeMoverIzquierda() = ((self.position().x() > 0) and self.tieneNaftaSuficiente())
	
	method puedeMoverDerecha() = ((self.position().x() <= 22) and self.tieneNaftaSuficiente())
	
	method menosVida(){
		if (self.position() == nivel1.naveEnemiga1().position() or self.position() == nivel1.naveEnemiga2().position() or self.position() == nivel1.naveEnemiga3().position()){
			if (vida >= 1){
				vida -=1
				sonidoPerderVida.sonar()
				if (vida == 0) {
					self.image("explosion.png")
		 			sonidoMorir.sonar()
					game.schedule(50,{game.removeVisual(self)})
					nivel1.perder()
				}
			}			
		}
}

	method menosNafta(cantidad){
		nafta -= cantidad
	}
	method cargarBalas(cantidad){
		balas += cantidad
	}
	method cargarNafta(cantidad){
		nafta += cantidad
	}
	
	
	
}

object posAleatoria {
	method posicionAleatoria(cant) {
		return game.at(cant.randomUpTo(game.width()-1).truncate(0),1.randomUpTo(game.height()-1).truncate(0))
	}
}

class Equipamiento {
	var property image
	var property position = posAleatoria.posicionAleatoria(4)
	method cambiarPosicion(){
		position = posAleatoria.posicionAleatoria(15)
	}
	
}
 
class TanqueDeNafta inherits Equipamiento {
	 method initialize() {
	 	image = "tanqueNafta.png"
	 }
	 
	 method teChoco(unaNave) {
	 	unaNave.cargarNafta(45)
	 	self.cambiarPosicion()
	 }
}

class Balas inherits Equipamiento {
	method initialize() {
	 	image = "balas.png"
	 }
	 
	 method teChoco(unaNave) {
	 	unaNave.cargarBalas(2)
	 	self.cambiarPosicion()
	 }
}

class AienEnemigo {
	var property image 
	var property position
	var property contadorVidas = self.vida()
	var property vida = 3
	
	method actualizar(){
		contadorVidas = self.vida()
	}

	method acercarseANave(){
    const otroPosicion2 = naveInicial.position()
    const newX2 = position.x() + if (otroPosicion2.x() > position.x()) 1 else -1
    const newY2 = position.y() + if (otroPosicion2.y() > position.y()) 1 else -1
    var encimaDeOtroAlien = false
    
    nivel1.enemigosLista().forEach { otroAlien =>
        if (otroAlien != self && otroAlien.position() == game.at(newX2, newY2)) {
            encimaDeOtroAlien = true
        }
    }
    if (!encimaDeOtroAlien) {
        position = game.at(newX2, newY2)
    } else {
    	position = game.at(newX2, self.position().y())
    }
}
	
	
	
	method teChoco(unaNave) {
	 	unaNave.menosVida()
	 }
	
	method recibirDisparo(cantidad){
		
		if (vida != 0){
		 vida -= cantidad
		 	if (vida == 0) {
		 	self.image("explosion.png")
			game.schedule(50,{game.removeVisual(self)})
			sonidoMorir.sonar()
			game.schedule(50, {nivel1.visuales().remove(self)})
			game.schedule(50,{nivel1.enemigosLista().remove(self)})
			game.schedule(50,{position = game.at(99,99)})
		 	}
		}
	}
}

object vidas{
	var property position = game.at(1,13)
	var property image = "3corazon.png"

	method image(){
		if (naveInicial.vida() > 0) {return naveInicial.vida().toString() + "corazon.png"}
		else {return "perdiste.png"}
		}
	
	method teChoco(algo) {}
}
object contadorNafta{
	var property position = game.at(1,12)
	var property image = "contadorNafta.png"
	
	method teChoco(algo) {}
}

object contadorBalas{
	var property position = game.at(1,11)
	var property image = "contadorBalas.png" 
	
	method teChoco(algo) {}
}

object cantidadBalas{
	var property position = game.at(4,11)
	var property textColor= "#FFFFFF"
	var text = naveInicial.balas()
	
	method actualizar(){
		text = naveInicial.balas()
	}
	
	method text() = text.toString()
	
	method teChoco(algo) {}
}



object cantidadNafta{
	var property position = game.at(4,12)
	var property textColor= "#FFFFFF"
	var text = naveInicial.nafta()
	
	method actualizar(){
		text = naveInicial.nafta()
	}
	
	method text() = text.toString()
	
	method teChoco(algo) {}
}

object vidasNivel3{
	var property position = game.at(4,9)		

	var property image = "3corazon.png"

	method image(){
		if (naveInicialNivel3.contadorVidas()>= 1) {return naveInicialNivel3.contadorVidas().toString() + "corazon.png"}
		else {return "perdiste.png"}
		}
		
	method teChoco(algo) {}
}
class VidasNivel3{
	var property numero 
	var property position
	
		method image(){ 
		var img
		if (numero==1){img = "halcon444.png"}
		else if(numero==2){img = "acorazado.png"}			
		return img
	}
	method teChoco(algo) {}	
}
class VidasEnemigos5{	
	var property naveEspacial 
	var property position
	var property image = "5corazonEnemigo.png"

	method image() = naveEspacial.contadorVidas().toString() + "corazonEnemigoNivel3.png"
	method teChoco(algo) {}
}
class VidasEnemigos3{	
	var property naveEspacial 
	var property position
	var property image = "3corazonEnemigo.png"

	method image() = naveEspacial.contadorVidas().toString() + "corazonEnemigo.png"
	method teChoco(algo) {}
}

class VidasEnemigos{
	var property numero 
	var property position
	
	method image() = "vidaEnemigo" + numero.toString() + ".png"
	method teChoco(algo) {}
}

class Fondo {
	var property position = game.at(0,0)
	var property image 
	
	method teChoco(algo) {}
}
