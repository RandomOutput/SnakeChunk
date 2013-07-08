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
	
	public class MenuState extends FlxState
	{	
		private var m_background:FlxGroup;
		private var m_foreground:FlxSprite;
		private var m_goal:MenuGoalZone;
		private var m_static:FlxSprite;
		private var m_sepia:FlxSprite;
		
		private var m_t1:FlxSound;
		private var m_t2:FlxSound;
		private var m_t3:FlxSound;
		private var m_t4:FlxSound;
		private var m_t5:FlxSound;

		public static const T1_MIX_VOLUME:Number = 1;
		
		
		public function MenuState()
		{
			super();
		}
		
		override public function create():void
		{
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
			
			m_background = new Background([]);
			m_goal = new MenuGoalZone(289, 450);

			m_foreground = new FlxSprite(0,0);
			m_foreground.loadGraphic(menuForegroundImage, false, false, 700, 600);

			add(m_background);
			add(new MousePointer());
			add(m_goal);
			add(m_static);
			add(m_foreground);
			add(m_sepia);

			m_t1 = FlxG.play(T1, T1_MIX_VOLUME, true);
		}
		
		override public function update():void
		{
			super.update();
		}
		

		[Embed(source="/images/static.png")]
		private static var staticImage:Class;

		[Embed(source="/images/sepia.png")]
		private static var sepiaImage:Class;

		[Embed(source="/images/menuForeground.png")]
		private static var menuForegroundImage:Class;
		
		[Embed(source="/sounds/menuLoop.mp3")] 	
		private static var T1:Class;
		
		//private static var Music
		
		
	}
	
}