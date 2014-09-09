package src 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import src.utils.Vector2D;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class Player extends Sprite
	{
		public var ammo : int = 15;  
		private var maxAmmo : int = 15;
		private var mousePosition : Vector2D = new Vector2D();
		
		public function Player() 
		{
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, -5, 30, 10);
			graphics.endFill();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movement);
		}
		
		private function movement(e:MouseEvent):void 
		{
			this.rotation = 0;
			mousePosition.x = this.mouseX;
			mousePosition.y = this.mouseY;
			this.rotation = mousePosition.angle * 180 / Math.PI;
		}
		
		public function reload():void {
			
			ammo = maxAmmo;
		}
		
	}

}