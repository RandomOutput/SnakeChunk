package
{
	import flash.display.StageQuality;
	
	import org.flixel.FlxGame;

	[SWF(width="700", height="600", backgroundColor=0xFFFFFF)] 

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(700,600,MenuState,1);
			stage.quality = StageQuality.LOW;
		}
		
	}
}