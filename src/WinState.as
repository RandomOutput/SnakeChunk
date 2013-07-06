package
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class WinState extends FlxState
	{
		public function WinState()
		{
			super();
		}
		
		override public function create():void
		{
			var text:FlxText = new FlxText(200, 200, 500, "A WINNER IS YOU");
			text.setFormat(null, 24, 0xff000000);
			add(text);
		}
	}
	
	
}