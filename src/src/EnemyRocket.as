package src 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class EnemyRocket extends Rocket
	{	
		public function EnemyRocket() 
		{
			super();
			
			graphics.clear();
			
			graphics.beginFill(0x000000, 1);
			graphics.drawCircle(20, 0, 2);
			graphics.endFill();
			
			graphics.beginFill(0x8C4439, 1);
			graphics.drawRect(0, -2, 20, 4);
			graphics.endFill();
			
			id = 2;
			speed = 1.3;
		}
	}
}