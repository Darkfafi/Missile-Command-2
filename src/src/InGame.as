package src 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import src.utils.Vector2D;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class InGame extends MovieClip 
	{
		private var towers : Array = [];
		
		private var rockets : Array = [];
		
		private var explosions : Array = [];
		
		private var _location : Vector2D = new Vector2D();
		private var _velocity : Vector2D = new Vector2D();
		private var shotClicked : Vector2D = new Vector2D();
		
		
		public function InGame() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
			for (var i : int = 0; i < 3; i++) {
				
				createTower();
				towers[i].x = stage.stageWidth * (i * 0.5);
				
				towers[i].y = stage.stageHeight - towers[i].height / 2;
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
		}
		
		private function shoot(e:MouseEvent):void {
			
			var chooseTower : int = Math.random() * towers.length
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
					
					explode(i);
				}
				
			}
			
			for (var j : int = 0; j < explosions.length; j++) {
				
				if(explosions[j].maxSize == false){
					explosions[j].scaleX += 0.1;
					explosions[j].scaleY += 0.1;
				}
				else {
					explosions[j].scaleX -= 0.1;
					explosions[j].scaleY -= 0.1;
				}
				if(explosions[j].scaleX > 4) { // <-- max grote van de explosie
					explosions[j].maxSize = true;
				}
				if (explosions[j].scaleX < 0) {
					removeChild(explosions[j]);
					explosions.splice(j, 1);
				}
			}
		}
		
		public function explode(i : int):void {
			
			var explosion : Explosion = new Explosion();
			
			explosion.x = rockets[i].x;
			explosion.y = rockets[i].y;
			explosions.push(explosion);
			addChild(explosion);
					
			removeChild(rockets[i]);
			rockets.splice(i, 1);
			
		}
		
		private function spawnEnemyRockets():void {
			
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
	}

}