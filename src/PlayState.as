package
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class PlayState extends FlxState
	{	
		public static const START_COUNT:int = 40;
		public static const SPACER_VAL:int = 30;
		public static const COL_DIST:int = 15;
		public static const SPEED:Number = 60;
		public static const NODES_PER_ROW:int = 10;
		public static const START_X:int = 600;
		public static const START_Y:int = 100;
		public static const START_TIME:int = 100;

		private var m_background:FlxGroup;
		private var m_chunks:FlxGroup;
		private var m_collideCooldown:uint = 0;
		private var m_timer:GameTimer;
		private var m_overlappedLastFrame:Object;
		private var m_overlappedThisFrame:Object;
		private var m_snake:SnakeChunk;
		private var m_goal:GoalZone;
		private var m_splitOnceThisCollision:Boolean;
		private var m_splitID:String;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			var xSwap:int = 1;

			FlxG.bgColor = 0xffffff;
			m_background = new Background();
			
			m_timer = new GameTimer(20, 20, START_TIME);
			m_chunks = new FlxGroup();
			var head:SnakeChunk = new SnakeChunk(START_X, START_Y, SnakeChunk.PLAYER);
			var last_pos:FlxPoint = new FlxPoint(START_X, START_Y);
			m_snake = head;
			m_chunks.add(head);
			m_overlappedLastFrame = {};
			for(var i:int = 0; i < START_COUNT; ++i)
			{
				if(i % NODES_PER_ROW == 0)
				{
					xSwap *= -1;
				}
				var nextPos:FlxPoint = new FlxPoint(last_pos.x + (xSwap * 35), START_Y + (Math.floor(i / NODES_PER_ROW) * 80));
				var next:SnakeChunk = new SnakeChunk(nextPos.x, nextPos.y, SnakeChunk.BODY);
				last_pos = nextPos;
				var nextType:int = Math.floor(Math.random() * 3) + 3;
				next.setBreakType(nextType);
				next.ahead = head;
				head.behind = next;
				m_chunks.add(next);
				head = next;
			}
			
			m_goal = new GoalZone(450, 400);
			add(m_background);
			add(m_goal);
			add(m_chunks);
			add(m_timer);
		}
		
		override public function update():void
		{
			super.update();
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
			//if(FlxCollision.pixelPerfectCheck(chunk1 as FlxSprite, chunk2 as FlxSprite))
			//use distance based collision
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
								}
								else if(snake2.mode == SnakeChunk.PLAYER && snake1.ahead.mode != SnakeChunk.PLAYER)
								{
									snake1.split();
									m_splitOnceThisCollision = true;
									m_splitID = key;
								}
							}
						}
						else
						{
							/*
							trace("Snake Collision");
							var tail:SnakeChunk;
							if(getStartOf(snake2).mode != SnakeChunk.PLAYER)
							{
								tail = getEndOf(snake1);
								snake1.ahead = tail;
								tail.behind = getStartOf(snake2);
							} else if(getStartOf(snake1).mode != SnakeChunk.PLAYER)
							{
								tail = getEndOf(snake2);
								snake2.ahead = tail;
								tail.behind = getStartOf(snake1);
							}*/
							if(getStartOf(snake1).mode == SnakeChunk.PLAYER || getStartOf(snake2).mode == SnakeChunk.PLAYER)
							{
								//if snake2 is player head
								if(snake2.ahead == null && snake2.mode == SnakeChunk.PLAYER && !m_splitOnceThisCollision)
								{								
									destroyNode(snake1);
								}
								//if snake1 is the player head
								else if(snake1.ahead == null && snake1.mode == SnakeChunk.PLAYER && !m_splitOnceThisCollision)
								{
									destroyNode(snake2);
								}
								else if(snake2.ahead == null && snake2.mode != SnakeChunk.BODY && snake2.mode != SnakeChunk.PLAYER && !m_splitOnceThisCollision)
								{
									var tail:SnakeChunk = getEndOf(snake1);
									snake2.ahead = tail;
									tail.behind = snake2;
								}
								else if(snake1.ahead == null && snake1.mode != SnakeChunk.BODY && snake1.mode != SnakeChunk.PLAYER && !m_splitOnceThisCollision)
								{	
									tail = getEndOf(snake2);
									snake1.ahead = tail;
									tail.behind = snake1;
								}
							}
								
						}
					}
					m_overlappedThisFrame[key] = true;
				}
			}
		}

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

		
		
	}
	
}