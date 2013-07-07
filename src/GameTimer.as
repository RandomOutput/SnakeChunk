package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	public class GameTimer extends FlxGroup
	{
		private var m_timer:FlxText;
		private var m_timeLimit:uint;
		public var isComplete:Boolean;

		private var digit_1:FlxSprite;
		private var digit_2:FlxSprite;
		private var digit_3:FlxSprite;
		private var digit_4:FlxSprite;

		public function GameTimer(X:Number=0, Y:Number=0, time:uint = 60)
		{	
			super();

			digit_1 = new FlxSprite(X, Y);
			digit_2 = new FlxSprite(X + 60, Y);
			digit_3 = new FlxSprite(X + 120, Y);
			digit_4 = new FlxSprite(X + 180, Y);

			digit_1.loadGraphic(clock_strip, true, false, 51, 51, false);
			digit_2.loadGraphic(clock_strip, true, false, 51, 51, false);
			digit_3.loadGraphic(clock_strip, true, false, 51, 51, false);
			digit_4.loadGraphic(clock_strip, true, false, 51, 51, false);


			add(digit_1);
			add(digit_2);
			add(digit_3);
			//add(digit_4);

			m_timeLimit = FlxU.getTicks() + time * 1000;
			m_timer = new FlxText(X, Y, 500, FlxU.formatTime(time, false));
			m_timer.setFormat(null, 24, 0xff000000);
			isComplete = false;
			//add(m_timer);
		}
		
		override public function update():void
		{
			super.update();
			if(FlxU.getTicks() < m_timeLimit)
			{
				var remaining:int = m_timeLimit - FlxU.getTicks();

				remaining = Math.floor(remaining / 10);
				digit_4.frame = Math.floor(remaining % 10);
				remaining = Math.floor(remaining / 10);
				digit_3.frame = Math.floor(remaining % 10);
				remaining = Math.floor(remaining / 10);
				digit_2.frame = Math.floor(remaining % 10);
				remaining = Math.floor(remaining / 10);
				digit_1.frame = Math.floor(remaining % 10);
				remaining = Math.floor(remaining / 10);
				

				//m_timer.text = FlxU.formatTime((m_timeLimit - FlxU.getTicks()) / 1000, false);
			}
			else
			{
				m_timer.text = FlxU.formatTime(0, false);
				isComplete = true;
			}
			
		}

		[Embed(source="/images/clock_strip.png")]
		private static var clock_strip:Class;
	}
}