package src 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import src.utils.Vector2D;
	
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class InGame extends MovieClip 
	{
		private var rocketFactory : RocketFactory = new RocketFactory();
		
		private var allTowers : Array = [];
		private var activeTowers : Array = [];
		
		private var rockets : Array = [];
		
		public var explosions : Array = [];
		
		private var _location : Vector2D = new Vector2D();
		private var _velocity : Vector2D = new Vector2D();
		private var shotClicked : Vector2D = new Vector2D();
		
		private var level : int = 1;
		private var totalRocketsMade : int = 0;
		private var totalRocketsSpawn : int;
		
		private var totalTowers : int = 3;
		
		public function InGame() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			createBackground(0x6495ed, 0x696969);
			
			levelSpawnSystem();
			
		}
		
		private function createBackground(colorSky : uint,colorGround : uint):void {
			
			graphics.beginFill(colorSky, 1);
			graphics.drawRect(0, 0, 800, 600);
			graphics.endFill();
			
			graphics.beginFill(colorGround, 1);
			graphics.drawRect(0, 550, 800, 50);
			graphics.endFill();
		}
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			createTowers(totalTowers);
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, shoot);
		}
		
		private function createTowers(t : int):void {
			for (var i : int = 0; i < t; i++) {
				
				var player : Player = new Player();
				addChildAt(player,0);
				activeTowers.push(player);
				allTowers.push(player);
				
				activeTowers[i].x = stage.stageWidth / (t - 1) * i;
				
				activeTowers[i].y = stage.stageHeight - activeTowers[i].height - 25;
				activeTowers[i].rotation = 270;
			}
		}
		
		private function loop(e:Event):void 
		{	
			rocketsUpdate();
			
			if (totalRocketsMade >= totalRocketsSpawn && checkForEnemyRockets() == false) {
				
				trace("Level Complete!");
				
				var la : int = activeTowers.length;
				var lb : int = allTowers.length;
				for (var j : int = la; j >= 0; j--) {
					for (var i : int = lb; i >= 0; i--) {
						//activeTowers[i].reload();
						activeTowers.splice(i, 1);
					}
					if(allTowers[j] != null){
						removeChild(allTowers[j]);
						//trace("removing!!!!!!")
					}
					allTowers.splice(j,1);
				}
				
				createTowers(totalTowers);
				
				level ++;
				totalRocketsMade = 0;
				levelSpawnSystem();
				
			}
			
		}
		private function checkForEnemyRockets():Boolean {
			
			for (var i : int = 0; i < rockets.length; i++) {
				
				if (rockets[i].id == 2) {
					
					return true;
					break;
				}
			}
			return false;
		}
		
		private function shoot(e:MouseEvent):void {
			
			var close : Number = new Number(Number.MAX_VALUE);
			var chosenTower : Player;
			if(activeTowers.length > 0){
				
				for (var i : int = 0; i < activeTowers.length; i++) {
					
					if (activeTowers[i].mouseX + activeTowers[i].mouseY < close && activeTowers[i].ammo > 0) {
						close = activeTowers[i].mouseX + activeTowers[i].mouseY;
						chosenTower = activeTowers[i];
					}	
				}
				trace("Ammo: " + chosenTower.ammo);
				
				if(chosenTower.ammo > 0){
					chosenTower.ammo -= 1;
					
					var rocket : Rocket = rocketFactory.makeRocket(RocketFactory.NORMAL_ROCKET);
					
					rocket.x = chosenTower.x;
					rocket.y = chosenTower.y;
					
					rocket.rotation = chosenTower.rotation;
					
					rocket.destination = mouseY;
					
					var xMove:Number = Math.cos(rocket.rotation / 180 * Math.PI);
					var yMove:Number = Math.sin(rocket.rotation / 180 * Math.PI);
					
					rocket.movement.x = xMove;
					rocket.movement.y = yMove;
					
					rockets.push(rocket);
					
					addChildAt(rocket,0);
				}
			}
		}
		
		private function rocketsUpdate():void 
		{
			
			for (var i : int = 0; i < rockets.length; i++) {
				
				rockets[i].update();
				
				if (rockets[i].id == 2 && rockets[i].y >= rockets[i].target.y) {
					
					var index : int = activeTowers.indexOf(rockets[i].target);
					
					if(activeTowers[index] != null){
						//removeChild(activeTowers[index]);
						activeTowers.splice(index, 1);
					}
					explode(rockets[i]);
					
				}else if (rockets[i].id == 1 && rockets[i].y <= rockets[i].destination) {
					
					explode(rockets[i]);
				}
					
				//hit test with explosions
				for (var k : int = 0; k < explosions.length; k++) {
					if(rockets[i] != null){
						if (explosions[k].hitTestObject(rockets[i]) && rockets[i].id == 2) {
							explode(rockets[i]);
						}
					}
				}
			}
			
			for (var j : int = 0; j < explosions.length; j++) {
				
				if(explosions[j].maxSize == false){
					explosions[j].scaleX += 0.2;
					explosions[j].scaleY += 0.2;
				}
				else {
					explosions[j].scaleX -= 0.2;
					explosions[j].scaleY -= 0.2;
				}
				if(explosions[j].scaleX > 7) { // <-- max grote van de explosie
					explosions[j].maxSize = true;
				}
				if (explosions[j].scaleX < 0) {
					removeChild(explosions[j]);
					explosions.splice(j, 1);
				}
			}
			
		}
		
		public function explode(target : DisplayObject):void {
			
			var explosion : Explosion = new Explosion();
			
			explosion.x = target.x;
			explosion.y = target.y;
			explosions.push(explosion);
			addChild(explosion);
					
			removeChild(target);
			var index : int = rockets.indexOf(target);
			rockets.splice(index, 1);
		}
		
		private function spawnEnemyRockets(totalRockets : int):void {
			for (var i : int = 0; i < totalRockets; i++ ){
				var enemyRocket : Rocket = rocketFactory.makeRocket(RocketFactory.NORMAL_ENEMY_ROCKET);
				
				enemyRocket.x = Math.random() * stage.stageWidth; 
				enemyRocket.y = 0 - enemyRocket.width;
				
				var randomTower : int = Math.random() * activeTowers.length; 
				
				var tri : Point = new Point(activeTowers[randomTower].x - enemyRocket.x, activeTowers[randomTower].y - enemyRocket.y);
				
				enemyRocket.rotation = Math.atan2(tri.y, tri.x) * 180 / Math.PI;
				trace(enemyRocket.rotation);
				
				var xMove:Number = Math.cos(enemyRocket.rotation / 180 * Math.PI);
				var yMove:Number = Math.sin(enemyRocket.rotation / 180 * Math.PI);
					
				enemyRocket.movement.x = xMove;
				enemyRocket.movement.y = yMove;
				
				enemyRocket.target = activeTowers[randomTower];
				trace(enemyRocket.target);
				
				rockets.push(enemyRocket);
				
				addChild(enemyRocket);
			}
			totalRocketsMade += totalRockets;
			trace(totalRocketsMade + " <-- made/ total --> " + totalRocketsSpawn);
			levelSpawnSystem();
		}
		
		private function levelSpawnSystem():void {
			
			totalRocketsSpawn = 12 * (level / 2);
			
			if(totalRocketsMade < totalRocketsSpawn){
				var delay : int = 6000;
				
				var timeUntilNextWave : Number = setTimeout(spawnEnemyRockets, delay, (Math.floor(Math.random() * level + 3)));
			}
		}
	}
}