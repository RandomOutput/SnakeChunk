package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	[SWF(width="700", height="600", backgroundColor="#000000")] 

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(700,600,PlayState,1);
		}
		
	}
}