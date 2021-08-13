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

class EpilipseWarning extends MusicBeatState
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
				"CAUTION:\n" +
				"this 'ere addon contains lots o' strobes!\n\n" +
				'give it a toggle in the options menu',
			32);
		} else {
			txt = new FlxText(0, 0, FlxG.width,
				"WARNING:\n" +
				'this mod contains flashing lights\n\n' +
				'you can turn this off in the settings',
			32);
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
