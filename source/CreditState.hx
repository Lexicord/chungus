package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditState extends MusicBeatState
{

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<CreditIcon> = [];
	private var grpLabels:FlxTypedGroup<Alphabet>;

	var theFuckingPeople:Array<String> = [
		'ash',
		'crystal',
		'leonz',
		'nonsense',
		'aboalrok',
		'hugenate',
		'munky',
		'joey animations',
		'octopox',
		'riveroaken',
		'lexicord',
		'madbear',
		'daniel voltage',
		'brightfyre',
		'endigo'
	];
	var theFuckingLabels:Array<String> = [
		'programmer and speedrunner',
		'balls man',
		'leonz',
		'nonsense',
		'aboalrok',
		'charting and Humongous Nathaniel',
		'munky',
		'joey animations',
		'octopox',
		'riveroaken',
		'lexicord',
		'madbeat422',
		'daniel voltage',
		'brightfyre',
		'endigo'
	];
	var theFuckingLinks:Array<String> = [
		'https://twitter.com/ash__i_guess_',
		'https://www.youtube.com/channel/UCjGfaP-eiT-XGeCRjGM9fGQ',
		'https://www.youtube.com/channel/UCnp4LuZgNt0KwiTMSZN7GIw',
		'https://twitter.com/AboAlrokArt',
		'https://twitter.com/HugeNate_',
		'https://twitter.com/munkyfr_?s=09',
		'https://www.youtube.com/channel/UCRLsZwUPm7Ax4ZZ3lgM77Ng',
		'https://www.youtube.com/channel/UCD2md2vRkKR06uvnpSiGw0Q',
		'https://twitter.com/river_oaken?s=09',
		'https://twitter.com/Lexicord2',
		'https://www.youtube.com/channel/UCuUWs5LR42EaSwtI_IqxO-w',
		'https://www.youtube.com/channel/UC7dmhduVprBZypLJm46xiEg',
		'https://www.youtube.com/c/BrightFyre/',
		'https://www.youtube.com/user/Endigo'
	];
	override function create()
	{
		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Credits Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		FlxG.mouse.visible = true;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/chungbg'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		/*grpLabels = new FlxTypedGroup<Alphabet>();
		add(grpLabels);*/
		for (i in 0...theFuckingPeople.length)
		{
			var songText:Alphabet = new Alphabet(0, (150 * i) + 100, theFuckingPeople[i], true, false, true);
			songText.x += 300;
			grpSongs.add(songText);

			var elBallso:Alphabet = new Alphabet(-20, (150 * i) + 40, theFuckingLabels[i], true, false, true);
			elBallso.x += 310;
			elBallso.scale.set(0.5, 0.5);
			grpSongs.add(elBallso);

			var icon:CreditIcon = new CreditIcon(i, theFuckingLinks[i]);
			icon.elSprite = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.mouse.wheel < 0) {
			if (grpSongs.members[grpSongs.length - 1].y > 600) {
				for (i in grpSongs) {
					i.y += FlxG.mouse.wheel * 30;
				}
			}
		}
		if (FlxG.mouse.wheel > 0) {
			if (grpSongs.members[0].y < 100) {
				for (i in grpSongs) {
					i.y += FlxG.mouse.wheel * 30;
				}
			}
		}
		for (i in iconArray) {
			if (FlxG.mouse.overlaps(i)) {
				i.scale.set(1, 1);
				if (FlxG.mouse.justPressed) {
					#if linux
					Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
					#else
					FlxG.openURL(i.link);
					#end
				}
			} else {
				i.scale.set(0.9, 0.9);
			}
		}
	}
}

class CreditIcon extends FlxSprite
{
	public var link:String;
	public var elSprite:FlxSprite;
	public function new(num:Int, link:String)
	{
		this.link = link;
		super();
		loadGraphic(Paths.image('shitassCedits'), true, 150, 150);

		antialiasing = true;
		animation.add('balls', [num], 0, false);

		scrollFactor.set();
		animation.play('balls');
	}
	override function update(balls:Float) {
		if (elSprite != null) {
			x = elSprite.x - 200;
			y = elSprite.y - 75;
		}
		super.update(balls);
	}
	
}
