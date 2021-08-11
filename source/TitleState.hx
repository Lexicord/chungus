package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var crdSpr:FlxSprite;
	var extrSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}

		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });

		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
	new FlxTimer().start(2, function(tmr:FlxTimer)
	{
			var rating:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('rating'));
			rating.antialiasing = true;
			rating.scrollFactor.set(0.9, 0.9);
			rating.active = false;
			rating.screenCenter();
			add(rating);

			FlxG.sound.play(Paths.sound('deez'), 1);
		new FlxTimer().start(0.75, function(tmr:FlxTimer)
		{
			FlxG.sound.play(Paths.sound('boom'), 1);
		});
		new FlxTimer().start(3.25, function(tmr:FlxTimer)
		{
			remove(rating);
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		});
	});
		}

		Conductor.changeBPM(126);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(-200, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		crdSpr = new FlxSprite(0, 0).loadGraphic(Paths.image('introCredit'));
		add(crdSpr);
		crdSpr.visible = false;
		crdSpr.setGraphicSize(Std.int(crdSpr.width * 0.65));
		crdSpr.updateHitbox();
		crdSpr.screenCenter();
		crdSpr.antialiasing = true;

		extrSpr = new FlxSprite(0, 0).loadGraphic(Paths.image('extraCred'));
		add(extrSpr);
		extrSpr.visible = false;
		extrSpr.setGraphicSize(Std.int(extrSpr.width * 0.5));
		extrSpr.updateHitbox();
		extrSpr.screenCenter();
		extrSpr.y += 150;
		extrSpr.antialiasing = true;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		initialized = true;

		// credGroup.add(credTextShit);
		
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new MainMenuState());
		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				crdSpr.visible = true;
				createCoolText([' ', ' ', ' ', ' ', ' ']);
			case 3:
				addMoreText('presents');
			case 4:
				crdSpr.visible = false;
			  deleteCoolText();
			case 5:
				createCoolText(['Featuring']);
			case 7:
				addMoreText('Leonz');
				addMoreText('Octopox');
				extrSpr.visible = true;
			case 8:
				deleteCoolText();
				extrSpr.visible = false;
			case 9:
				createCoolText([curWacky[0]]);
			case 10:
				addMoreText(curWacky[1]);
			case 11:
				deleteCoolText();
			case 12:
				addMoreText(curWacky[1]);
			case 13:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 14:
				addMoreText(curWacky[1]);
			case 15:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 16:
				addMoreText(curWacky[1]);
			case 17:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 18:
				addMoreText(curWacky[1]);
			case 19:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 20:
				addMoreText(curWacky[1]);
			case 21:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 22:
				addMoreText(curWacky[1]);
			case 23:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 24:
				addMoreText(curWacky[1]);
			case 25:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 26:
				addMoreText(curWacky[1]);
			case 27:
				curWacky = FlxG.random.getObject(getIntroTextShit());
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 28:
				addMoreText(curWacky[1]);
			case 29:
				deleteCoolText();
				if (Math.random() < 0.5)
					addMoreText('Big');
				else
					addMoreText('Friday');
			case 30:
				if (Math.random() < 0.5)
					addMoreText('Chun');
				else
					addMoreText('Night');
			case 31:
				if (Math.random() < 0.5)
					addMoreText('Gus');
				else
					addMoreText('Funkin');
			case 32:
				FlxG.switchState(new MainMenuState());
		}
	}
}
