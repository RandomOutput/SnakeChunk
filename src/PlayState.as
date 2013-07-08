package
{	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{	
		public static const START_COUNT:int = 20;
		public static const SPACER_VAL:int = 30;
		public static const COL_DIST:int = 20;
		public static const SPEED:Number = 100;
		public static const NODES_PER_ROW:int = 7;
		public static const START_X:int = 500;
		public static const START_Y:int = 200;
		public static const START_TIME:int = 90;
		
		
		public static const T0_MIX_VOLUME:Number = .8;
		public static const T1_MIX_VOLUME:Number = 1;
		public static const T2_MIX_VOLUME:Number = .6;
		public static const T3_MIX_VOLUME:Number = 1;
		public static const T4_MIX_VOLUME:Number = 1;
		public static const T5_MIX_VOLUME:Number = 1;
		
		public var m_snake:SnakeChunk;

		private var m_background:FlxGroup;
		private var m_chunks:FlxGroup;
		private var m_collideCooldown:uint = 0;
		private var m_timer:GameTimer;
		private var m_overlappedLastFrame:Object;
		private var m_overlappedThisFrame:Object;
		private var m_goal:GoalZone;
		private var m_splitOnceThisCollision:Boolean;
		private var m_splitID:String;
		private var m_static:FlxSprite;
		private var m_sepia:FlxSprite;
		private var m_explosion:FlxEmitter;
		
		
		private var m_t0:FlxSound;
		private var m_t1:FlxSound;
		private var m_t2:FlxSound;
		private var m_t3:FlxSound;
		private var m_t4:FlxSound;
		private var m_t5:FlxSound;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			var xSwap:int = 1;

			FlxG.bgColor = 0xffffff;
			m_static = new FlxSprite();
			m_static.loadGraphic(staticImage, true, false, 700, 600);
			m_static.blend = 'overlay';
			m_static.alpha = .75;
			m_static.addAnimation('go', [0,1,2,3], 10, true);
			m_static.play('go');

			m_sepia = new FlxSprite();
			m_sepia.loadGraphic(sepiaImage, true, false, 700, 600);
			m_sepia.blend = 'overlay';
			m_sepia.alpha = .5;
			
			m_timer = new GameTimer(265, 35, START_TIME);
			m_chunks = new FlxGroup();
			var head:SnakeChunk = new SnakeChunk(START_X, START_Y, SnakeChunk.PLAYER, this);
			var last_pos:FlxPoint = new FlxPoint(START_X, START_Y);
			m_snake = head;
			m_chunks.add(head);
			m_overlappedLastFrame = {};
			var chunks:Array = [];
			chunks.push(head);
			for(var i:int = 0; i < START_COUNT; ++i)
			{
				if(i % NODES_PER_ROW == 0)
				{
					xSwap *= -1;
				}
				var nextPos:FlxPoint = new FlxPoint(last_pos.x + (xSwap * 35), START_Y + (Math.floor(i / NODES_PER_ROW) * 80));
				var next:SnakeChunk = new SnakeChunk(nextPos.x, nextPos.y, SnakeChunk.BODY, this);
				last_pos = nextPos;
				var nextType:int = Math.floor(Math.random() * 3) + 3;
				//var nextType:int = 5;
				next.setBreakType(nextType);
				next.ahead = head;
				head.behind = next;
				m_chunks.add(next);
				head = next;
				chunks.push(head);
			}
			
			
			m_explosion = new FlxEmitter(10, FlxG.height / 2, 250);
			m_explosion.setXSpeed(-500, 500);
			m_explosion.setYSpeed( -500, 500);
			
			
			for (var j:int = 0; j < m_explosion.maxSize/2; j++) {
				var whitePixel:FlxParticle = new FlxParticle();
				whitePixel.makeGraphic(3, 3, 0x4d000000);
				whitePixel.visible = false; //Make sure the particle doesn't show up at (0, 0)
				m_explosion.add(whitePixel);
				whitePixel = new FlxParticle();
				whitePixel.makeGraphic(2, 2, 0x4d000000);
				whitePixel.visible = false;
				m_explosion.add(whitePixel);
			}
			
			
			m_background = new Background(chunks);
			m_goal = new GoalZone(289, 450);
			add(m_background);
			add(new MousePointer());
			add(m_goal);
			add(m_explosion);
			add(m_static);
			add(m_chunks);
			add(m_timer);
			add(m_sepia);
			m_t1 = FlxG.play(T0, T0_MIX_VOLUME, false);
			m_t1 = FlxG.play(T1, T1_MIX_VOLUME, false);
			m_t2 = FlxG.play(T2, 0, false);
			m_t3 = FlxG.play(T3, 0, false);
			m_t4 = FlxG.play(T4, 0, false);
			m_t5 = FlxG.play(T5, 0, false);
		}
		
		override public function update():void
		{
			super.update();
			
			var percent:Number = (getChainLength(m_snake) - 2) / ((START_COUNT - 2) * 1.0);
			
			m_t2.volume = FlxU.bound(((1 - percent) - .1) * 4, 0, 1) * T2_MIX_VOLUME;
			m_t3.volume = FlxU.bound(((1 - percent) - .5) * 4, 0, 1) * T3_MIX_VOLUME;
			m_t4.volume = FlxU.bound(((1 - percent) - .6) * 4, 0, 1) * T4_MIX_VOLUME;
			m_t5.volume = FlxU.bound(((1 - percent) - .75) * 4, 0, 1) * T5_MIX_VOLUME;
			
			
			m_goal.checkSnake(m_snake)
			FlxG.bgColor = 0xffffff;
			m_overlappedThisFrame = {};
			m_splitOnceThisCollision = m_splitID != null && m_overlappedLastFrame[m_splitID];
			if(!m_splitOnceThisCollision)
			{
				m_splitID = null;
			}
			FlxG.overlap(m_chunks, null, overlap);
			m_overlappedLastFrame = m_overlappedThisFrame;
			
			if(m_timer.isComplete)
			{
				if(!m_goal.checkSnake(m_snake))
				{
					FlxG.switchState(new LossState());
				}
				else
				{
					FlxG.switchState(new WinState());
				}
			}
		}
		
		protected function overlap(chunk1:FlxObject, chunk2:FlxObject):void
		{
			if(FlxU.getDistance(new FlxPoint(chunk1.x, chunk1.y), new FlxPoint(chunk2.x, chunk2.y)) < COL_DIST)
			{
				if(chunk1 is SnakeChunk && chunk2 is SnakeChunk)
				{
					var snake1:SnakeChunk = chunk1 as SnakeChunk;
					var snake2:SnakeChunk = chunk2 as SnakeChunk;
					
					var key:String = snake1.chunkID < snake2.chunkID ? snake1.chunkID + "_" + snake2.chunkID : snake2.chunkID + "_" + snake1.chunkID;
					
					if(!m_overlappedLastFrame[key])
					{
						if(snake1.chainID == snake2.chainID)
						{
							if(!m_splitOnceThisCollision)
							{
								if(snake1.mode == SnakeChunk.PLAYER && snake2.ahead.mode != SnakeChunk.PLAYER)
								{
									snake2.split();
									m_splitOnceThisCollision = true;
									m_splitID = key;
									swapPlayer(snake1, snake2);
								}
								else if(snake2.mode == SnakeChunk.PLAYER && snake1.ahead.mode != SnakeChunk.PLAYER)
								{
									snake1.split();
									m_splitOnceThisCollision = true;
									m_splitID = key;
									swapPlayer(snake1, snake2);
								}
							}
						}
						else
						{
							if((getStartOf(snake1).mode == SnakeChunk.PLAYER || getStartOf(snake2).mode == SnakeChunk.PLAYER) && !(snake1.isDisabled() || snake2.isDisabled()))
							{
								if(snake2.ahead == null && snake2.mode != SnakeChunk.BODY && snake2.mode != SnakeChunk.PLAYER && !m_splitOnceThisCollision)
								{
									var tail:SnakeChunk = getEndOf(snake1);
									snake2.ahead = tail;
									tail.behind = snake2;
									FlxG.play(COMBINE, 0.5, false, true);
								}
								else if(snake1.ahead == null && snake1.mode != SnakeChunk.BODY && snake1.mode != SnakeChunk.PLAYER && !m_splitOnceThisCollision)
								{	
									tail = getEndOf(snake2);
									snake1.ahead = tail;
									tail.behind = snake1;
									FlxG.play(COMBINE, 0.5, false, true);
								}
							}
								
						}
					}
					m_overlappedThisFrame[key] = true;
				}
			}
		}

		public function swapPlayer(snake1:SnakeChunk, snake2:SnakeChunk):void
		{
			var splitOffChunk:SnakeChunk = snake1.chainID != m_snake.chainID ? snake1 : snake2.chainID != m_snake.chainID ? snake2 : null;
			if(getChainLength(snake1) > getChainLength(snake2) && m_snake.chainID != snake1.chainID)
			{
				//trace("swap for 1");
				var snake1Head:SnakeChunk = getStartOf(snake1);
				splitOffChunk = m_snake.behind;
				m_snake.behind.split(); //disconnect player from chain
				m_snake.behind = snake1Head; //connect head to new chain
				snake1Head.ahead = m_snake; //connnect new chain to head
			}
			else if(getChainLength(snake1) <= getChainLength(snake2) && m_snake.chainID != snake2.chainID)
			{
				//trace("swap for 2");
				var snake2Head:SnakeChunk = getStartOf(snake2);
				splitOffChunk = m_snake.behind;
				m_snake.behind.split(); //disconnect player from chain
				m_snake.behind = snake2Head; //connect head to new chain
				snake2Head.ahead = m_snake; //connnect new chain to head
			}
			splitOffChunk = getStartOf(splitOffChunk);
			splitOffChunk.disable();
			m_explosion.x = splitOffChunk.x + splitOffChunk.origin.x;
			m_explosion.y = splitOffChunk.y + splitOffChunk.origin.y;
			m_explosion.start(true, 1, 0.1, 50);
			FlxG.play(CHUNK, 0.5, false, true);
		}
		/*
		public function destroyNode(dead_node:SnakeChunk):void
		{
			if(!dead_node.ahead) //if it is a head
			{
				if(dead_node.behind) //if it has a tail
				{
					dead_node.behind.split(); //split from the tail
				}
				//dead_node.destroy(); //remove the node
				m_chunks.remove(dead_node); 
				dead_node = null;
			}
			else if(!dead_node.behind) //if it is a tail
			{
				dead_node.split(); //remove it from the chain
				//dead_node.destroy(); //remove the node
				m_chunks.remove(dead_node);
				dead_node = null;
			}
			else //if it is in the body
			{
				dead_node.split(); //remove it from the chain ahead
				dead_node.behind.split(); //remove it from the chain behind
				//dead_node.destroy(); //remove the node
				m_chunks.remove(dead_node);
				dead_node = null;
			}
		}
		*/
		public function getStartOf(snake:SnakeChunk):SnakeChunk
		{
			var visited:Object = {};
			var current:SnakeChunk = snake;
			while(current.ahead != null)
			{
				if(visited[current.chunkID])
				{
					var last:SnakeChunk = current.behind;
					current.split();
					return last;
				}
				visited[current.chunkID] = true;
				current = current.ahead;
			}
			return current;
		}

		public function getChainLength(snake:SnakeChunk):int
		{
			var tail:SnakeChunk = getEndOf(snake);
			var len:int = 0;
			while(tail.ahead)
			{
				len++;
				tail = tail.ahead;
			}
			return len;
		}
		
		public function getEndOf(snake:SnakeChunk):SnakeChunk
		{
			var visited:Object = {};
			var current:SnakeChunk = snake;
			while(current.behind != null)
			{
				if(visited[current.chunkID])
				{
					var last:SnakeChunk = current.ahead;
					current.split();
					return last;
				}
				visited[current.chunkID] = true;
				current = current.behind;
			}
			return current;
		}

		[Embed(source="/images/static.png")]
		private static var staticImage:Class;

		[Embed(source="/images/sepia.png")]
		private static var sepiaImage:Class;
		
		[Embed(source="/sounds/Eccentricity  game-T0-openBell.mp3")]	
		private static var T0:Class;
		
		[Embed(source="/sounds/Eccentricity-T1-Piano.mp3")] 	
		private static var T1:Class;
		
		[Embed(source="/sounds/Eccentricity  game-T2-bells.mp3")] 	
		private static var T2:Class;
		
		[Embed(source="/sounds/Eccentricity  game-T3-backPiano.mp3")] 	
		private static var T3:Class;
		
		[Embed(source="/sounds/Eccentricity  game-T4-perc1.mp3")] 	
		private static var T4:Class;
		
		[Embed(source="/sounds/Eccentricity  game-T5-perc2.mp3")] 	
		private static var T5:Class;
		
		
		[Embed(source="/sounds/chunk.mp3")] 	
		private static var CHUNK:Class;
		
		[Embed(source="/sounds/combine.mp3")] 	
		private static var COMBINE:Class;
		
		
	}
	
}