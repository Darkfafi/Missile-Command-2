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
			graphics.beginFill(0xff4500);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
		}
		
	}

}