package;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;
import flixel.plugin.MouseEventManager;
import flash.filters.GlowFilter;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	//32x24
	public static var grid = { rows:12, columns:7, size:30, x:13, y:2 };
	public static var human_matrix = [ [0, 0, 1, 1, 1, 0, 0],
										[0, 0, 1, 1, 1, 0, 0],
										[0, 0, 1, 1, 1, 0, 0],
										[0, 1, 1, 1, 1, 1, 0],
										[0, 1, 1, 1, 1, 1, 0],
										[0, 1, 1, 1, 1, 1, 0],
										[0, 0, 1, 0, 1, 0, 0],
										[0, 0, 1, 0, 1, 0, 0],
										[0, 0, 1, 0, 1, 0, 0],
										[0, 0, 1, 0, 1, 0, 0],
										[0, 0, 1, 0, 1, 1, 0],
										[0, 0, 0, 0, 0, 0, 0] ];
										
										
	var background:FlxSprite = new FlxSprite();
	var cats:Array<Cat> = new Array<Cat>();
	var stars:Array<FlxSprite> = new Array<FlxSprite>();
	var bed:FlxRect;
	var timer:FlxTimer;
	var selectedCat:Cat = null;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		background.makeGraphic(1024, 600, FlxColor.NAVY_BLUE);
		add(background);
		
		var squareSize = 20;
		var gridLine:LineStyle = { color: FlxColor.YELLOW, thickness: 2 };
		var blockedLine:LineStyle = { color: FlxColor.BLACK, thickness: 2 };
		var points = [new FlxPoint(30, 30), new FlxPoint(30+squareSize, 30), new FlxPoint(30+squareSize, 30+squareSize), new FlxPoint(30, 30+squareSize)];
		//FlxSpriteUtil.drawPolygon(background, points, 0, lineStyle);
		
		//for (i in 0...grid.columns+1) {
			//FlxSpriteUtil.drawLine(background, grid.x+(i*grid.size), grid.y, grid.x+(i*grid.size), grid.y+(grid.rows*grid.size),gridLine);
		//}
		//for (i in 0...grid.rows+1) {
			//FlxSpriteUtil.drawLine(background, grid.x, grid.y+(i*grid.size), grid.x+(grid.columns*grid.size), grid.y+(i*grid.size),gridLine);
		//}
		var gridX = grid.x * grid.size;
		var gridY = grid.y * grid.size;
		var bed1:Bed = new Bed(gridX, 0);
		add(bed1);
		for (i in 0...grid.columns) {
			for (j in 0...grid.rows) {
				if (human_matrix[j][i] == 1) {
					FlxSpriteUtil.drawRect(background,gridX+(i*grid.size), gridY+(j*grid.size),grid.size, grid.size,FlxColor.TRANSPARENT, blockedLine);
				} else {
					if (nearHuman(i, j)) {
						FlxSpriteUtil.drawRect(background,gridX+(i*grid.size), gridY+(j*grid.size),grid.size, grid.size,FlxColor.RED);
					} else {
						FlxSpriteUtil.drawRect(background,gridX+(i*grid.size), gridY+(j*grid.size),grid.size, grid.size,FlxColor.YELLOW);
					}
				}
				
			}
		}
		setStars();
		bed = new FlxRect(grid.x, grid.y, grid.columns * grid.size, grid.rows * grid.size);
		//var sound:FlxSound = FlxG.sound.load(AssetPaths.cat2__ogg);
		//trace(AssetPaths.cat2__ogg);
		
		//sound.play();
		//var sound:FlxSound = new FlxSound();
		//sound.loadEmbedded(AssetPaths.cat2__ogg);
		//sound.play();
		
		timer = new FlxTimer(3.0, myCallback, 0);		
		super.create();
	}
	
	private function handleStars(on:Bool) {
		for (star in stars) {
			if (on) {
				add(star);
				MouseEventManager.add(star, null, null, onMouseOver, null); 
			} else {
				remove(star);
				MouseEventManager.remove(star);
			}
		}
	}
	
	private function setStars() {
		var gridX = grid.x * grid.size;
		var gridY = grid.y * grid.size;
		for (i in 0...grid.rows) {
			var star1:FlxSprite = new FlxSprite(gridX - grid.size, gridY + grid.size * i, AssetPaths.star__png);
			var star2:FlxSprite = new FlxSprite(gridX +grid.columns*grid.size, gridY + grid.size * i, AssetPaths.star__png);
			stars.push(star1);
			stars.push(star2);
			//MouseEventManager.add(star1, null, null, onMouseOver, null); 
			//MouseEventManager.add(star2, null, null, onMouseOver, null); 
		}
		for (i in 0...grid.columns) {
			var star1:FlxSprite = new FlxSprite(gridX + grid.size*i, gridY + grid.size * grid.rows, AssetPaths.star__png);
			stars.push(star1);
			//MouseEventManager.add(star1, null, null, onMouseOver, null); 
		}
	}
	
	function onMouseOver(sprite:FlxSprite) {
		trace("overstar");
		//var filter = new GlowFilter(0xFF0000, 1, 50, 50, 1.5, 1);
		//var flxsf:FlxSpriteFilter = new FlxSpriteFilter(sprite,30,30);
		//flxsf.addFilter(filter);
	}
	
	private function myCallback(timer:FlxTimer):Void{
		generateCat();
	}
	
	function inBounds(col:Int, row:Int) {
		return col >= 0 && col < grid.columns && row >= 0 && row < grid.rows;
	}
	
	function nearHuman(col:Int, row:Int) 
	{
		for (i in col-1...col+2) {
			for (j in row-1...row+2) {
				if (inBounds(i, j) && human_matrix[j][i]==1) {
					return true;
				}
				
			}
		}
		return false;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	function generateCat() {
		var cat:Cat = new Cat(600, 450, FlxRandom.color(), FlxRandom.intRanged(1, 5));
		for (part in cat.sortedParts()) {
			add(part);
		}
		
		var randomPoint:FlxPoint = getRandomPoint();
		//FlxSpriteUtil.drawEllipse(background, randomPoint.x, randomPoint.y, 3, 3, FlxColor.TRANSPARENT,  { color: FlxColor.RED, thickness: 2 });
		//trace(randomPoint);
		cat.goto(randomPoint);
		cats.push(cat);
		if (cats.length == 10) {
			timer.destroy();
		}
	}
	
	function getRandomPoint():FlxPoint {
		var xRand = FlxRandom.intRanged(0, 32);
		var yRand = FlxRandom.intRanged(0, 24);
		if (xRand >=grid.x && xRand < grid.x+grid.columns && yRand >=grid.y && yRand < grid.y+grid.rows) {
			return getRandomPoint();
		} else {
			return new FlxPoint(xRand*grid.size, yRand*grid.size);
		}
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		for (cat in cats) {
			cat.update();
		}
		//if (FlxG.mouse.justReleased)
		//{
			//var mousePoint = FlxG.mouse.getScreenPosition();
			//var newPoint = new FlxPoint(mousePoint.x, mousePoint.y);
			//FlxSpriteUtil.drawEllipse(background, newPoint.x, newPoint.y, 3, 3, FlxColor.TRANSPARENT,  { color: FlxColor.RED, thickness: 2 });
			//cats[0].goto(newPoint);
		//}
		//for (swipe in FlxG.swipes){
			//trace(swipe.startPosition);
			//trace(swipe.endPosition);
		//}
		
		for (touch in FlxG.touches.list)
		{
			
			if (touch.justPressed)
			{
				pressed(touch.x,touch.y);
			}

			if (touch.pressed)
			{
				justPressed(touch.x,touch.y);
			}

			if (touch.justReleased)
			{
				justReleased(touch.x,touch.y);
			}
		}
		if (FlxG.mouse.pressed) 
		{
			pressed(FlxG.mouse.x,FlxG.mouse.y);
		}

		if (FlxG.mouse.justPressed) 
		{
			justPressed(FlxG.mouse.x,FlxG.mouse.y);
		}

		if (FlxG.mouse.justReleased) 
		{
			justReleased(FlxG.mouse.x,FlxG.mouse.y);
		}
		super.update();
	}
	
	
	function getSelected(x:Float, y:Float) {
		for (cat in cats) {
			if (cat.selected(x, y)) {
				return cat;
			}
		}
		return null;
	}
	
	function justPressed(x:Float, y:Float) {
		//trace(x+" "+y);
		//trace("justpressed");
		selectedCat = getSelected(x, y);
		if (selectedCat != null) {
			add(selectedCat.miau);
			handleStars(true);
		}
	}
	function pressed(x:Float, y:Float) {
		if (selectedCat != null) {
			//trace("going");
			selectedCat.goto(new FlxPoint(x, y));
		}
	}
	function justReleased(x:Float, y:Float) {
		//trace(x+" "+y);
		//trace("released");
		if (selectedCat != null) {
			remove(selectedCat.miau);
			selectedCat = null;
			handleStars(false);
		}
		
	}
}