package src 
{
	import flash.geom.Point;
	import src.EnemyRocket;
	import src.NormalRocket;
	/**
	 * ...
	 * @author Ramses di Perna
	 */
	public class RocketFactory 
	{
		
		public static const NORMAL_ROCKET : String = "normalRocket";
		public static const NORMAL_ENEMY_ROCKET : String = "normalEnemyRocket";
		
		public function makeRocket(	_type : String/*, _target*/): Rocket
		{
			
			var rocket : Rocket;
			
			if (_type == NORMAL_ROCKET) {
				
				rocket = new NormalRocket();
				
			}else if (_type == NORMAL_ENEMY_ROCKET) {
				
				rocket = new EnemyRocket();
				
			}
			return rocket;
		}
		
		
	}

}