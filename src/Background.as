package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	public class Background extends FlxGroup
	{
		private var m_background:FlxSprite;

		public function Background()
		{
			super();
			m_background = new FlxSprite();
			m_background.loadGraphic(backgroundImage, false, false, 707, 600);

			//add(m_background);

		}

		[Embed(source="/images/background.png")]
		private static var backgroundImage:Class;
	}
}