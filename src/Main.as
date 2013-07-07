package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	[SWF(width="700", height="600", backgroundColor=0xFFFFFF)] 

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(700,600,PlayState,1);
			//FlxG.visualDebug = true;
		}
		
	}
}