package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	public class GameTimer extends FlxGroup
	{
		private var m_timer:FlxText;
		private var m_timeLimit:uint;
		public var isComplete:Boolean;
		public function GameTimer(X:Number=0, Y:Number=0, time:uint = 60)
		{	
			super();
			m_timeLimit = FlxU.getTicks() + time * 1000;
			m_timer = new FlxText(X, Y, 500, FlxU.formatTime(time, false));
			m_timer.setFormat(null, 24);
			isComplete = false;
			add(m_timer);
		}
		
		override public function update():void
		{
			super.update();
			if(FlxU.getTicks() < m_timeLimit)
			{
				m_timer.text = FlxU.formatTime((m_timeLimit - FlxU.getTicks()) / 1000, false);
			}
			else
			{
				m_timer.text = FlxU.formatTime(0, false);
				isComplete = true;
			}
			
		}
	}
}