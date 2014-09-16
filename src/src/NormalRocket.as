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
	public class NormalRocket extends Rocket
	{
		
		public function NormalRocket() 
		{
			graphics.beginFill(0x000000, 1);
			graphics.drawCircle(20, 0, 2);
			graphics.endFill();
			
			graphics.beginFill(0x398B44, 1);
			graphics.drawRect(0, -2, 20, 4);
			graphics.endFill();
			
			id = 1;
			
			speed = 15;
		}
		
		public override function update():void {
			super.update();
		}
		
	}

}