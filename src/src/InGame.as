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
		private var towers : Array = [];
		
		private var rockets : Array = [];
		
		public var explosions : Array = [];
		
		private var _location : Vector2D = new Vector2D();
		private var _velocity : Vector2D = new Vector2D();
		private var shotClicked : Vector2D = new Vector2D();
		
		private var level : int = 1;
		private var totalRocketsMade : int = 0;
		private var totalRocketsSpawn : int;
		
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
			
			var totalTowers : int = 3;
			
			for (var i : int = 0; i < totalTowers; i++) {
				
				createTower();
				towers[i].x = stage.stageWidth / (totalTowers - 1) * i;
				
				towers[i].y = stage.stageHeight - towers[i].height - 25;
			}
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, shoot);
		}
		
		private function createTower():void {
			var player : Player = new Player();
			addChildAt(player,0);
			towers.push(player);
		}
		
		private function loop(e:Event):void 
		{	
			rocketsUpdate();
			
			if (totalRocketsMade >= totalRocketsSpawn && checkForEnemyRockets() == false) {
				
				trace("Level Compleat!");
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
			var chooseTower : int;
			
			for (var i : int = 0; i < towers.length; i++) {
				
				if (towers[i].mouseX + towers[i].mouseY < close) {
					close = towers[i].mouseX + towers[i].mouseY;
					chooseTower = i;
				}	
			}
			trace("Ammo: " + towers[chooseTower].ammo);
			
			if(towers[chooseTower].ammo > 0){
				towers[chooseTower].ammo -= 1;
				
				var rocket : Rocket = new Rocket();
				
				rocket.x = towers[chooseTower].x;
				rocket.y = towers[chooseTower].y;
				
				rocket.rotation = towers[chooseTower].rotation;
				
				rocket.destination = mouseY;
				
				var xMove:Number = Math.cos(rocket.rotation / 180 * Math.PI);
				var yMove:Number = Math.sin(rocket.rotation / 180 * Math.PI);
				
				rocket.movement.x = xMove;
				rocket.movement.y = yMove;
				
				rockets.push(rocket);
				
				addChildAt(rocket,0);
				//spawnEnemyRockets();
				
				
			}else {
				towers[chooseTower].reload();
			}
		}
		
		private function rocketsUpdate():void 
		{
			
			for (var i : int = 0; i < rockets.length; i++) {
				
				rockets[i].x += rockets[i].movement.x * rockets[i].speed;
				rockets[i].y += rockets[i].movement.y * rockets[i].speed;
				
				if (rockets[i].y <= rockets[i].destination) {
					
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
				var enemyRocket : EnemyRocket = new EnemyRocket();
				
				enemyRocket.x = Math.random() * stage.stageWidth; 
				enemyRocket.y = 0 - enemyRocket.width;
				
				var randomTower : int = Math.random() * towers.length; 
				
				var tri : Point = new Point(towers[randomTower].x - enemyRocket.x, towers[randomTower].y - enemyRocket.y);
				
				enemyRocket.rotation = Math.atan2(tri.y, tri.x) * 180 / Math.PI;
				
				var xMove:Number = Math.cos(enemyRocket.rotation / 180 * Math.PI);
				var yMove:Number = Math.sin(enemyRocket.rotation / 180 * Math.PI);
					
				enemyRocket.movement.x = xMove;
				enemyRocket.movement.y = yMove;
				
				rockets.push(enemyRocket);
				
				addChild(enemyRocket);
			}
			levelSpawnSystem();
		}
		
		private function levelSpawnSystem():void {
			
			totalRocketsSpawn = 12 * (level / 2);
			
			if(totalRocketsMade < totalRocketsSpawn){
				var delay : int = 6000;
				
				var timeUntilNextWave : Number = setTimeout(spawnEnemyRockets, delay, (Math.floor(Math.random() * level + 3)));
				totalRocketsMade += Math.floor(Math.random() * level + 3);
				trace(totalRocketsMade + " <-- made/ total --> " + totalRocketsSpawn);
			}
		}
	}
}