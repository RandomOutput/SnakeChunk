package
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class LossState extends FlxState
	{
		public function LossState()
		{
			super();
		}
		
		override public function create():void
		{
			var text:FlxText = new FlxText(200, 200, 500, "YOU JUST LOST THE GAME");
			text.setFormat(null, 24);
			add(text);
		}
	}
}