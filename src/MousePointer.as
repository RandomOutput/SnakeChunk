package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class MousePointer extends FlxGroup
	{
		
		protected var m_sprite:FlxSprite;
		protected var m_lastPoints:Array;
		public function MousePointer(MaxSize:uint=0)
		{
			super(MaxSize);
			m_lastPoints = [new FlxPoint()];
			m_sprite = new FlxSprite();
			m_sprite.makeGraphic(700, 600, 0x0);
			add(m_sprite);
		}
		
		override public function update():void
		{
			super.update();
			m_sprite.fill(0x0);
			for(var i:int = 0; i < 32 && i < m_lastPoints.length; ++i)
			{
				var p:FlxPoint = m_lastPoints[m_lastPoints.length - i - 1];
				m_sprite.drawLine(p.x, p.y, FlxG.mouse.screenX, FlxG.mouse.screenY, (int(255 * (32 - i) / 32) << 24) | 0xf43139);
			}
			m_lastPoints.push(new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY));
			if(m_lastPoints.length > 32)
			{
				m_lastPoints.shift();
			}
			
		}
	}
}