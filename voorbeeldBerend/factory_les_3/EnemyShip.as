package {
	import flash.display.Sprite;

	public class EnemyShip extends Sprite {
		
		private var _shipName	:	String;
		private var _speed		:	Number;
		private var _directionX	:	Number;
		private var _directionY	:	Number;
		private var _damage		:	Number;
		
		public function followHeroShip() : void
		{
			trace(shipName + " is following the hero");
		}
		
		public function shoot() : void
		{
			trace(shipName + " attacks and does " + damage + " damage to hero");
		}

		public function get damage() : Number {
			return _damage;
		}

		public function set damage(damage : Number) : void {
			_damage = damage;
		}

		public function get shipName() : String {
			return _shipName;
		}

		public function set shipName(shipName : String) : void {
			_shipName = shipName;
		}
		
	}
}
