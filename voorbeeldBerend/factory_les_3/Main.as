package 
{
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		public function Main()
		{
			// de factory wordt aangemaakt
			var enemyShipFactory : EnemyShipFactory = new EnemyShipFactory();
			
			// we vragen de ruimteschepen fabriek om een ruimteschip te maken
			var enemy : EnemyShip = enemyShipFactory.makeEnemyShip(EnemyShipFactory.UFO_ENEMY_SHIP);
			
			// het nieuwe ruimteschip mag gelijk acties ondernemen
			doEnemyStuff(enemy);		
		}
		
		private function doEnemyStuff( enemy : EnemyShip ) : void
		{
			enemy.followHeroShip();
			enemy.shoot();
		}
	}
}
