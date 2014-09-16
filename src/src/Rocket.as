package src 
{
	import flash.display.Sprite;
	import flash.geom.Point
	
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class Rocket extends Sprite
	{
		public var id : int = new int();
		
		public var speed : Number = new Number(); 
		
		public var movement : Point = new Point();
		
		public var destination : Number;
		
		public var target : Sprite = new Sprite();
		
		public function Rocket() 
		{
			
		}
		
		public function update():void {
			
			this.x += movement.x * speed;
			this.y += movement.y * speed;
			
		}
		
	}

}