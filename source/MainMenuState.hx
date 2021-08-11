package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];

	var newGaming:FlxText;
	var newGaming2:FlxText;
	
	var options:Array<FlxSprite>;

	var orange:FlxSprite;

	var origY:Float;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/chungbg'));
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(FlxG.width / FlxG.camera.zoom), Std.int(FlxG.height / FlxG.camera.zoom));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var chungtitle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/chungtitle'));
		chungtitle.scrollFactor.set();
		chungtitle.setGraphicSize(Std.int(FlxG.width / FlxG.camera.zoom), Std.int(FlxG.height / FlxG.camera.zoom));
		chungtitle.updateHitbox();
		chungtitle.screenCenter();
		chungtitle.antialiasing = true;
		add(chungtitle);

		var chungus:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/chung1'));
		chungus.scrollFactor.set();
		chungus.setGraphicSize(Std.int(FlxG.width / FlxG.camera.zoom), Std.int(FlxG.height / FlxG.camera.zoom));
		chungus.updateHitbox();
		chungus.screenCenter();
		chungus.antialiasing = true;
		add(chungus);

		orange = new FlxSprite().loadGraphic(Paths.image('menu/orange'));
		orange.scrollFactor.set();
		orange.setGraphicSize(Std.int(FlxG.width / FlxG.camera.zoom), Std.int(FlxG.height / FlxG.camera.zoom));
		orange.updateHitbox();
		orange.screenCenter();
		orange.antialiasing = true;
		origY = orange.y;
		add(orange);

		options = [];

		for (i in 0...optionShit.length)
		{
			var num:Int = i + 1;
			var menuItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/chungus' + num, 'preload'));
			menuItem.setGraphicSize(Std.int(FlxG.width / FlxG.camera.zoom), Std.int(FlxG.height / FlxG.camera.zoom));
			add(menuItem);
			options.push(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
			menuItem.screenCenter();
		}


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		
		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		orange.alpha = 0.6 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2.0) * 0.1;

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				for (i in 0...options.length)
				{
					if (curSelected != i)
					{
						FlxTween.tween(options[i], {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								options[i].kill();
							}
						});
					}
					else
					{
						if (FlxG.save.data.flashing)
						{
							FlxFlicker.flicker(options[i], 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								goToState();
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState();
							});
						}
					}
				}
			}
		}

		super.update(elapsed);
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		//FlxFlicker.flicker(options[curSelected], 1.1, 0.15, false);

		switch (daChoice)
		{
			case 'story mode':
				PlayState.storyPlaylist = ['BIG','CHUN','GUS'];
				PlayState.isStoryMode = true;

				var diffic = "";

				switch (2)
				{
					case 0:
						diffic = '-easy';
					case 2:
						diffic = '-hard';
				}

				PlayState.storyDifficulty = 2;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.storyWeek = 1;
				PlayState.campaignScore = 0;
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState(), true);
				});
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
			case 'credits':
				trace('entering credits');
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= options.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = options.length - 1;

		orange.y = origY + (curSelected * 28.25);

		for (i in 0...options.length)
		{
			options[i].alpha = 0.7;
			if (i == curSelected)
			{
				options[i].alpha = 1;
			}
		}
	}
}
