import wollok.game.*
import consola.*
import juego.*
import nivel2.*
import nivel3.*
import logicaNiveles.*

object nivel1 inherits LogicaNivel (audioNivel = game.sound("nivel1.mp3")) {
	
	const property fondo1 = new Fondo (image= "fondo1.png")
	const tanqueNafta1 = new TanqueDeNafta() 
	const tanqueNafta2 = new TanqueDeNafta()
	const cargarBalas1 = new Balas()
	const cargarBalas2 = new Balas()
	const property naveEnemiga1 = new AienEnemigo(image = "alienEnemigo.png",position = posAleatoria.posicionAleatoria(25)) 
	const property naveEnemiga2 = new AienEnemigo(image = "alienenemigo2.png",position = posAleatoria.posicionAleatoria(23))
	const property naveEnemiga3 = new AienEnemigo(image = "alienenemigo3.png",position = posAleatoria.posicionAleatoria(21))
	const property vidaNaveEnemiga1 = new VidasEnemigos3(naveEspacial = naveEnemiga1,position = game.at(19,13))
	const property vidaNaveEnemiga2 = new VidasEnemigos3(naveEspacial = naveEnemiga2,position = game.at(19,12))
	const property vidaNaveEnemiga3 = new VidasEnemigos3(naveEspacial = naveEnemiga3,position = game.at(19,11))
	const property vidasNaveEnenemiga1 = new VidasEnemigos(numero=1,position =  game.at(22,13))
	const property vidasNaveEnenemiga2 = new VidasEnemigos(numero=2,position =  game.at(22,12))
	const property vidasNaveEnenemiga3 = new VidasEnemigos(numero=3,position =  game.at(22,11))
	const property tanquesLista = [tanqueNafta1, tanqueNafta2]
	const property balasLista = [cargarBalas1, cargarBalas2]
	const property enemigosLista = [naveEnemiga1, naveEnemiga2, naveEnemiga3]
	
	override method visuales() = [fondo1, naveInicial, vidas, contadorNafta,cantidadNafta,vidasNaveEnenemiga1,vidasNaveEnenemiga2,vidasNaveEnenemiga3,vidaNaveEnemiga1,vidaNaveEnemiga2,vidaNaveEnemiga3, contadorBalas,cantidadBalas, naveEnemiga1,naveEnemiga2,naveEnemiga3,tanqueNafta1,tanqueNafta2,cargarBalas1,cargarBalas2]

	override method colisiones(){
		game.onCollideDo(naveInicial,{algo=>algo.teChoco(naveInicial)})
	}
	
	override method onTick(){
		game.onTick(900.randomUpTo(1500).truncate(0), "movimientoNaveEnemiga", {naveEnemiga1.acercarseANave()})
		game.onTick(1000.randomUpTo(1400).truncate(0), "movimientoNaveEnemiga", {naveEnemiga2.acercarseANave()})
		game.onTick(1100.randomUpTo(1300).truncate(0), "movimientoNaveEnemiga", {naveEnemiga3.acercarseANave()})
		
		game.onTick(1,"actualizar contador nafta",{cantidadNafta.actualizar()})
		game.onTick(1,"actualizar contador balas",{cantidadBalas.actualizar()})
		game.onTick(1,"pasar de nivel",{self.pasarASiguientePantalla()})
		game.onTick(1,"actualizar cantidad vidas enemigo1",{naveEnemiga1.actualizar()})
		game.onTick(1,"actualizar cantidad vidas enemigo2",{naveEnemiga2.actualizar()})
		game.onTick(1,"actualizar cantidad vidas enemigo3",{naveEnemiga3.actualizar()})
		game.onTick(90000,"perder por bug",{self.perder()})
		
		
	}
		
	method pasarASiguientePantalla() {
		if (self.enemigosLista() == []) {
			audioNivel.pause()
			game.clear()
			pantallaNivel2.configurar()
		}
	}
	
	method perder() {
		game.clear()
		audioNivel.pause()
		perdisteAudio.play()
		pantallaPerdiste.configurar()
	}
}
