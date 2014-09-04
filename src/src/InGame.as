package src 
{
	import flash.display.MovieClip;
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
		private var _location : Vector2D = new Vector2D();
		private var _velocity : Vector2D = new Vector2D();
		private var shotClicked : Vector2D = new Vector2D();
		
		//private var mousePosition : Vector2D;
		
		public function InGame() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			//mousePosition = new Vector2D();
			
			for (var i : int = 0; i < 3; i++) {
				
				createTower();
				towers[i].x = stage.stageWidth * (i* 0.5);
				//trace(towers[i].x);
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
			//movement();
			rocketsUpdate();
		}
		
		/*
		private function movement():void 
		{
			for (var i : int = 0; i < towers.length; i ++) {
				towers[i].rotation = 0;
				mousePosition.x = towers[i].mouseX;
				mousePosition.y = towers[i].mouseY;
				towers[i].rotation = mousePosition.angle * 180 / Math.PI;
			}
		}*/
		
		
		
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
				spawnEnemyRockets();
				
			}else {
				towers[chooseTower].reload();
			}
		}
		
		private function rocketsUpdate():void 
		{
			
			for (var i : int = 0; i < rockets.length; i++) {
				
				//var des : Vector2D = rockets[i].destination;
				//_location.x = rockets[i].x;
				//_location.y = rockets[i].y; 
				//var step : Vector2D = des.subtract(_location);
				//var unit : Vector2D = step.normalize();
				//_velocity = unit.multiply(rockets[i].speed);
				//rockets[i].y += _velocity.y;
				
				rockets[i].x += rockets[i].movement.x * rockets[i].speed;
				rockets[i].y += rockets[i].movement.y * rockets[i].speed;
				//trace(rockets[rockets.length - 1].y);
				if (rockets[i].y <= rockets[i].destination) {
					
					//explosion
					removeChild(rockets[i]);
					rockets.splice(i, 1);
				}
				
			}
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