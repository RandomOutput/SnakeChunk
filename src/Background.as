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
			m_background.loadGraphic(backgroundImage, true, false, 700, 600);
			m_background.addAnimation("shimmer", [0,1,2], 6, true);
			m_background.play("shimmer");

			add(m_background);

		}

		[Embed(source="/images/background.png")]
		private static var backgroundImage:Class;
	}
}