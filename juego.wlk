import wollok.game.*

object juego {
	method iniciar() {
		
		game.width(10)
		game.height(8)
		game.cellSize(50)
  		game.title("Espacio")
  		game.boardGround("cielo.jpg")
		
		game.addVisualCharacter(nave)
		game.addVisual(vida)
		self.generarAsteroides()
		self.generarPortales()
		
		game.onCollideDo(nave,{algo => algo.chocarNave()})
		
	}
	
	method generarAsteroides(){
		game.onTick(1000,"aparecer asteroides",{new Asteroide().aparecer()})
	}
	method generarPortales(){
		game.schedule(500,{new Portal().aparecer()})
	}
	method posicionAleatoriaAsteroides(){
		const x = (0.. game.width()-1).anyOne()
		const y = (game.height() - 1)
		return game.at(x, y)
	}
	method posicionAleatoriaPortales(){
		const x = (0.. game.width()-1).anyOne()
		const y = (0.. game.height()-1).anyOne()
		return game.at(x, y)
	}
	
	method gameover(){
		game.clear()
		game.addVisual(gameOver)
		}
	  
	}
object nave {
	var property position = game.at(4,1)
	var property vidas = 3
	const property image = "naveUp.png"
	var puntos = 0
	
	method moverDerecha(){
		position = position.right(1)
	}
	method moverIzquierda(){
		position = position.left(1)
	}
	method moverArriba(){
		position = position.up(1)
	}
	method moverAbajo(){
		position = position.down(1)
	}
	
	method perderVidas(){
		vidas -= 1
		if(vidas == 0){
			juego.gameover()
		}
	}
	method ganarPuntos(){
		puntos += 100
	}
}
class Asteroide{
	var property position = null
	
	method image() = "asteroide1.png"
	
	method aparecer(){
		position= juego.posicionAleatoriaAsteroides()
		game.addVisual(self)
		game.onTick(200, "movimiento", {self.caer()})
		game.schedule(3000,{self.desaparecer()})
	}
	method caer(){
		position = position.down(1)
	}
	method chocarNave(){
		nave.perderVidas()
		self.desaparecer()
	}
	method desaparecer(){
		if(game.hasVisual(self)){
			game.removeVisual(self)
		}
	}
}
class Portal{
	const property image = "portal.png"
	var property position = null
	
	method aparecer(){
		position = juego.posicionAleatoriaPortales()
		game.addVisual(self)
		//game.schedule(3000,{self.desaparecer()})
	}
	method chocarNave(){
		nave.ganarPuntos()
		game.removeVisual(self)
		juego.generarPortales()
	}
}
object vida{
	method  position() = game.at(9,7)
	method image() = "corazon.png"
	
	method text(){
		if (nave.vidas() == 3){
			return "3"
		}else if (nave.vidas() == 2){
			return "2"
		}else return "1"
	}
	method textColor()= "#FFFFFFFF"
	
	method chocarNave(){}

}

object gameOver{
	const property position = game.center()
	const property text = "GAME OVER"
	const property textColor = "#FFFFFFFF"
}
