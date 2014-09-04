package src 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import src.utils.Vector2D;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class Rocket extends Sprite 
	{
		public var id : int = 1;
		
		public var speed : int = 5; 
		
		public var movement : Point = new Point();
		
		public var destination : Number;
		
		public function Rocket() 
		{
			graphics.beginFill(0x00ff00, 1);
			graphics.drawRect(0, -2, 20, 4);
			graphics.endFill();
			
			graphics.beginFill(0x000000, 1);
			graphics.drawCircle(20, 0, 2);
			graphics.endFill();
		}
		
	}

}