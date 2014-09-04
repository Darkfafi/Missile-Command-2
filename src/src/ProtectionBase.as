package src 
{
	import flash.display.Sprite;
	import flash.events.DRMAuthenticationCompleteEvent;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class ProtectionBase extends Sprite
	{
		private var health : Number = 100;
		
		public function ProtectionBase() 
		{
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, 30, 30);
			graphics.endFill();
		}
		
		public function takeDamage(dmg : Number):void {
			
			health -= dmg;
			//later bij health drop verandering in kleur (uiterlijk)
		}
	}

}