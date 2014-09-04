package src 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class Explosion extends Sprite 
	{
		public var maxSize : Boolean = false;
		
		public function Explosion() 
		{
			graphics.beginFill(0x992266);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
		}
		
	}

}