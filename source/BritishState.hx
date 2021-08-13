package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class BritishState extends MusicBeatState
{

	override function create()
	{
		super.create();
		var theChung:String = 'menu/chungbg';
		if (FlxG.save.data.britishMode)
			theChung = 'menu/chungbg2';
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(theChung));
		add(bg);
			
		var txt:FlxText;
		if (FlxG.save.data.britishMode) {
			txt = new FlxText(0, 0, FlxG.width,
				"Ello, gov, You've still fucking british!\n" +
				"fuck you",
			32);
		} else {
			txt = new FlxText(0, 0, FlxG.width,
				"Ello, gov, You've unlocked bri'ish mode!\n" +
				"you're bri'ish now",
			32);
			MainMenuState.fuckingBrit = true;
		}
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
