package
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class GoalZone extends FlxSprite
	{
		
		protected var m_partialSound:FlxSound;
		protected var m_halfSound:FlxSound;
		protected var m_fullSound:FlxSound;
		
		protected var m_gracePeriod:uint;
		protected var m_volTween:Number;
		protected var m_state:String;
		
		public function GoalZone(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			loadGraphic(goalZoneImage, false, false, 97, 97);
			addAnimation("stage4", [0,1,2,3], 10, true);
			addAnimation("stage3", [4,5,6,7], 10, true);
			addAnimation("stage2", [8,9,10,11], 10, true);
			addAnimation("stage1", [12,13,14,15], 10, true);

			play("stage3");
			m_state = "stage3";
			m_partialSound = FlxG.play(partialSound, 0, true);
			m_halfSound = FlxG.play(halfSound, 0, true);
			m_fullSound = FlxG.play(fullSound, 0, true);
			
		}
		
		public function checkSnake(snake:SnakeChunk):Boolean
		{
			if(m_gracePeriod > FlxU.getTicks())
			{
				return true;
			}
			
			//trace("GO");
			if(!snake)
			{
				return false;
			}
			var head:SnakeChunk = snake;
			var count:int  = 0;
			var count_in:int = 0;
			while(head.ahead != null)
			{
				head = head.ahead;
			}
			if(head.mode != SnakeChunk.PLAYER)
			{
				return false;
			}
			
			var tail:SnakeChunk = head;
			
			while(tail)
			{
				if(FlxCollision.pixelPerfectCheck(tail as FlxSprite, this as FlxSprite))
				{
					count_in++;
				}
				tail = tail.behind;
				count++;
			}
			
			m_volTween = Math.min(1, m_volTween + 0.01);

			if(count == count_in)
			{
				
				play("stage4");
				if(m_state != "stage4")
				{
					m_volTween = 0;
				}
				m_state = "stage4";
				m_partialSound.volume = Math.min(m_partialSound.volume, (1-m_volTween));
				m_halfSound.volume = Math.min(m_halfSound.volume, (1-m_volTween));
				m_fullSound.volume = m_volTween;
				m_gracePeriod = 250;
				return true;
			}
			else if(count_in / count >= .5)
			{
				play("stage3");
				if(m_state != "stage3")
				{
					m_volTween = 0;
				}
				m_state = "stage3";
				m_partialSound.volume = Math.min(m_partialSound.volume, (1-m_volTween));
				m_halfSound.volume = m_volTween;
				m_fullSound.volume = Math.min(m_fullSound.volume, (1-m_volTween));
			}
			else if(count_in > 0)
			{
				play("stage2");
				if(m_state != "stage2")
				{
					m_volTween = 0;	
				}
				m_state = "stage2";
				m_partialSound.volume = m_volTween;
				m_halfSound.volume = Math.min(m_halfSound.volume, (1-m_volTween));
				m_fullSound.volume = Math.min(m_fullSound.volume, (1-m_volTween));
			}
			else
			{
				play("stage1");
				if(m_state != "stage1")
				{
					m_volTween = 0;
				}
				m_state = "stage1";
				m_partialSound.volume = Math.min(m_partialSound.volume, (1-m_volTween));
				m_halfSound.volume = Math.min(m_halfSound.volume, (1-m_volTween));
				m_fullSound.volume = Math.min(m_fullSound.volume, (1-m_volTween));
			}
			
			return false;
		}
		

		//*** Assets ***
		[Embed(source="/images/goal_strip_small.png")]
		private static var goalZoneImage:Class;
		
		

	}


}