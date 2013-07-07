//chunk_pink.png 62x62

package
{

	
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import PlayState;
	
	import SnakeMath.Quaternion;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	public class SnakeChunk extends FlxSprite
	{
		public static const PLAYER:int = 1;
		public static const BODY:int = 2;
		public static const RANDOM:int = 3;
		public static const INVADER:int = 4;
		public static const BOUNCY_SQUEEK:int = 5;

		private const PINK_SIZE:int = 41;
		private const PLAYER_SIZE_X:int = 72;
		private const PLAYER_SIZE_Y:int = 38;
		
		private static var s_nextID:int = 0;
		
		public static var WIDTH:int = 30
		public static var HEIGHT:int = 30;
		
		private var m_mode:int;
		private var m_type:int;
		private var m_lastVelocity:FlxPoint;
		private var m_ahead:SnakeChunk;
		private var m_behind:SnakeChunk;
		private var m_resetTime:uint;
		//for behavior
		private var m_dropTime:uint = 0;
		private var xSwap:int = 1;
		private var ySwap:int = 1;
		
		public var lastY:Number;
		public var lastX:Number;
		
		public var chainID:uint;
		public var chunkID:uint;
		
		private var m_disableTimer:uint;
		private var m_disabled:Boolean;
		private var m_cloned:BitmapData;
		
		private static var s_desat:ColorMatrixFilter = new ColorMatrixFilter(new Array(0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0, 0, 0, 1, 0));
		private static var s_resat:ColorMatrixFilter = new ColorMatrixFilter(new Array(1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0));
		
		public function get nextID():int
		{
			return ++s_nextID;
		}
		
		public function SnakeChunk(X:int, Y:int, mode:int)
		{
			super(X, Y, null);
			lastX = X;
			lastY = Y;
			

			loadGraphic(playerChunkImage, false, false, PLAYER_SIZE_X, PLAYER_SIZE_Y);
			WIDTH = PLAYER_SIZE_X;
			HEIGHT = PLAYER_SIZE_Y;

			m_mode = mode;
			if(m_mode != BODY)
			{
				chainID = nextID;
			}
			chunkID = nextID;
			m_lastVelocity = new FlxPoint(0,0);
		}
		
		public function disable():void
		{
			m_cloned = framePixels.clone();
			this.framePixels.applyFilter(m_cloned, framePixels.rect, new Point(), s_desat);
			velocity = FlxVelocity.velocityFromAngle(Math.random() * 360, 300);
			m_disabled = true;
			if(m_behind)
			{
				m_behind.disable();
			}
			m_disableTimer = FlxU.getTicks() + 3000;
		}
		
		public function isDisabled():Boolean
		{
			return m_disabled;
		}
		
		private function turnToFace(desiredAngle, ca:Number, turnSpeed:Number):Number
		{   
			var q1:Quaternion = Quaternion.createFromAxisAngle(0, 1, 0, FlxMath.asRadians(desiredAngle));
			var q2:Quaternion = Quaternion.createFromAxisAngle(0, 1, 0, FlxMath.asRadians(ca));
			var qOut:Quaternion = Quaternion.slerp(q2, q1, .02);
			var outAngle:Number = FlxMath.asDegrees(qOut.toEuler().x);
			return outAngle; 
		}
		
		public override function update():void
		{
			m_lastVelocity = new FlxPoint(velocity.x, velocity.y);
			lastX = x;
			lastY = y;
			super.update();
			
			if(m_disableTimer < FlxU.getTicks() )//|| mode == BODY)
			{
				switch(m_mode)
				{
					case PLAYER:
						if(FlxVelocity.distanceToMouse(this) > 10)
						{
							var target:Number = FlxVelocity.angleBetweenMouse(this, true);
							angle = turnToFace(target, angle, 1);
							this.velocity = FlxVelocity.velocityFromAngle(angle, PlayState.SPEED);
						}
						else
						{
							this.velocity.x = 0;
							this.velocity.y = 0;
						}
						break;
					case BODY:
						if(m_ahead != null)
						{
							var distance:Number = Math.max(FlxU.getDistance(new FlxPoint(x, y), new FlxPoint(m_ahead.lastX, m_ahead.lastY)), Number.MIN_VALUE);
							var newVelocity:FlxPoint = new FlxPoint((m_ahead.lastX - x) / distance, (m_ahead.lastY - y) / distance);
							var dot:Number = newVelocity.x * m_ahead.lastVelocity.x + newVelocity.y * m_ahead.lastVelocity.y;
							
							//space out node after player head
							if(this.ahead.mode == SnakeChunk.PLAYER)
							{
								velocity.x = newVelocity.x * dot * .3 + velocity.x * .7 + (newVelocity.x * (distance - PlayState.SPACER_VAL - 25));
								velocity.y = newVelocity.y * dot * .3 + velocity.y * .7 + (newVelocity.y * (distance - PlayState.SPACER_VAL - 25));
							} 
							else //normal
							{
								velocity.x = newVelocity.x * dot * .3 + velocity.x * .7 + (newVelocity.x * (distance - PlayState.SPACER_VAL));
								velocity.y = newVelocity.y * dot * .3 + velocity.y * .7 + (newVelocity.y * (distance - PlayState.SPACER_VAL));
							}
						}
						break;
					case RANDOM:
						if(FlxU.getTicks() > m_resetTime)
						{
							velocity.x = Math.random() - .5;
							velocity.y = Math.random() - .5;
							distance = Math.max(FlxU.getDistance(ZERO, velocity), Number.MIN_VALUE);
							velocity.x =  (velocity.x / distance) * 100;
							velocity.y = (velocity.y / distance)  * 100;
							m_resetTime = FlxU.getTicks() + Math.random() * 3000;
						}
						break;
					case INVADER:
						if(FlxU.getTicks() > m_dropTime)
						{
							velocity.x = xSwap * 100;
							velocity.y = 0;
							
							if(x > 700 - width || x < 0)
							{
								xSwap *= -1;
								m_dropTime = FlxU.getTicks() + Math.max(Math.random() * 1500, 250);
							} 
						} 
						else
						{
							velocity.y = ySwap * 50;
							velocity.x = 0;
							if(y > 600 - height || y < 0)
							{
								ySwap *= -1;
							}
						}
					break;
					case BOUNCY_SQUEEK:
						
					
					break;
					default:
					if(FlxU.getTicks() > m_resetTime)
					{
						velocity.x = Math.random() - .5;
						velocity.y = Math.random() - .5;
						distance = Math.max(FlxU.getDistance(ZERO, velocity), Number.MIN_VALUE);
						velocity.x =  (velocity.x / distance) * 100;
						velocity.y = (velocity.y / distance)  * 100;
						m_resetTime = FlxU.getTicks() + Math.random() * 3000;
					}
					break;
				}
				
			}
			else if(m_disabled)
			{
				velocity.x *= .99;
				velocity.y *= .99;
			}
			if(m_disabled && m_disableTimer < FlxU.getTicks())
			{
				this.framePixels.applyFilter(m_cloned, framePixels.rect, new Point(), s_resat);
				m_disabled = false;
			}
			if(mode != PLAYER)
			{
				var perpendicular:FlxPoint = new FlxPoint(velocity.y, -velocity.x);
				angle = FlxU.getAngle(ZERO, perpendicular);
			}
			
			if(x > 700 - width)
			{
				x = 700 - width;
				velocity.x *= -.5;
				m_resetTime = 0;
			}
			if(x < 0)
			{
				x = 0;
				velocity.x *= -.5;
				m_resetTime = 0;
			}
			if(y > 600 - height)
			{
				y = 600 - height;
				velocity.y *= -.5;
				m_resetTime = 0;
			}	
			if(y < 0)
			{
				y = 0;
				velocity.y *= -.5;
				m_resetTime = 0;
			}	
		}
		
		public function get lastVelocity():FlxPoint
		{
			return m_lastVelocity;
		}
		
		public function setBreakType(type:int = RANDOM):void
		{
			m_type = type;

			trace("MODE: " + type);
			
			switch(type)
			{
				case 3:
					loadGraphic(redChunkImage, false, false, PINK_SIZE, PINK_SIZE);
					WIDTH = PINK_SIZE;
					HEIGHT = PINK_SIZE;
					break;	
				case 4: 
					loadGraphic(pinkChunkImage, false, false, PINK_SIZE, PINK_SIZE);
					WIDTH = PINK_SIZE;
					HEIGHT = PINK_SIZE;
					break;
				case 5: 
					loadGraphic(purpleChunkImage, false, false, PINK_SIZE, PINK_SIZE);
					WIDTH = PINK_SIZE;
					HEIGHT = PINK_SIZE;
					break;
				default:
					makeGraphic(25, 25, 0xffff0000); 
				break;
			}
		}
		
		public function get mode():int
		{
			return m_mode;
		}
		
		public function set mode(newMode:int):void
		{
			m_mode = newMode;
		}
		
		public function set ahead(chunk:SnakeChunk):void
		{
			if(chunk == null)
			{
				m_ahead = null
			}
			else if(m_mode != PLAYER)
			{
				if(m_ahead == null)
				{
					m_ahead = chunk;
					m_mode = BODY;
					setChainID(chunk.chainID);
				}
				else
				{
					trace("AHEAD ALREADY SET");
				}
			}
			else
			{
				trace("CAN'T SET AHEAD ON PLAYER");
			}
		}
		
		public function get ahead():SnakeChunk
		{
			return m_ahead;
		}
		
		public function set behind(chunk:SnakeChunk):void
		{
			if(chunk == null)
			{
				m_behind = null
			}
			else if(m_behind == null)
			{
				m_behind = chunk;
				m_behind.setChainID(chunk.chainID);
			}
			else
			{
				trace("BEHIND ALREADY SET");
			}
		}
		
		public function get behind():SnakeChunk
		{
			return m_behind;
		}
		
		public function setChainID(id:int):void
		{
			if(m_behind != null)
			{
				m_behind.setChainID(id);
			}
			chainID = id;
		}
		
		private function chunk(id:int, chunkSize:int = 2, count:int = 0):void
		{
			if(count > chunkSize)
			{
				split();
			}
			else
			{
				if(m_behind != null)
				{
					m_behind.chunk(id, chunkSize, ++count);
				}
				chainID = id;
			}
		}
		
		public function split():void
		{
			if(m_ahead)
			{
				m_mode = m_type;
				setChainID(nextID);
				//chunk(nextID, int(Math.random() + .5) + 2);
				m_ahead.m_behind = null;
				m_ahead = null;
			}
		}

		//*** Assets ***
		[Embed(source="/images/chunk_pink.png")]
		private static var pinkChunkImage:Class;

		[Embed(source="/images/chunk_purple.png")]
		private static var purpleChunkImage:Class;

		[Embed(source="/images/chunk_red.png")]
		private static var redChunkImage:Class;

		[Embed(source="/images/chunk_player.png")]
		private static var playerChunkImage:Class;
	}
}