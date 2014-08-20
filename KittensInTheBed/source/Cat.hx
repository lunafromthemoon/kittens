package ;
import flash.display.Bitmap;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
/**
 * ...
 * @author LunaFromTheMoon
 */
class Cat
{

	public var colour:Int;
	public var size:Int;
	public var parts:Array<FlxSprite>;
	public var nextStop:FlxPoint = null;
	public var miau:FlxText = new FlxText(0, 0, -1, "Miau!");
	public static var SPEED:Float = 2;
	var state:CatState = CatState.Sit;
	var stepCount:Int = 0;
	public function new(x:Int, y:Int, colour:Int,size:Int ) 
	{
		miau.x = x;
		miau.y = y;
		this.colour = colour;
		this.size = size;
		this.parts = new Array<FlxSprite>();
		var catLine:LineStyle = { color: this.colour, thickness: 2 };
		for (i in 0...this.size) {
			var img = i == 0 ? AssetPaths.head__png : AssetPaths.body__png;
			var part:FlxSprite = new FlxSprite(x,y + i * 20,img);
			this.parts.push(part);
		}		
		updateMiau();
		//FlxG.sound.play(AssetPaths.cat2__mp3);
	}
	
	public function sortedParts():Array<FlxSprite>{
		var copy = this.parts.copy();
		copy.reverse();
		return copy;
	}
	
	private function updateMiau() 
	{
		miau.x = parts[0].x;
		miau.y = parts[0].y-10;
	}
	
	public function goto(point:FlxPoint) {
		nextStop = new FlxPoint(point.x, point.y);
		state = CatState.Walking;
	}
	
	public function update() {
		if (nextStop != null) {
			var currentPlace:FlxPoint = new FlxPoint(parts[0].x, parts[0].y);
			if (FlxGeom.vdistsqr(currentPlace, nextStop) < SPEED) {
				nextStop = null;
				state = Sitting;				
			} else {
				var angle:Float = FlxGeom.angle(currentPlace,nextStop);
				//trace(angle);
				var newPos:FlxPoint = FlxGeom.vPoint(currentPlace, SPEED, -angle);
				parts[0].x = newPos.x;
				parts[0].y = newPos.y;
				parts[0].angle = FlxGeom.toDegrees(-angle)+90;
				updateMiau();
				followHead(20,false);
			}
		} else {
			if (state == Sitting) {
				if (20 - SPEED * stepCount > 0) {
					followHead(20 - SPEED * stepCount,true);
					stepCount++;
				} else {
					state = Sit;
					stepCount = 0;
				}
				
			}
		}
	}
	
	private function followHead(step:Float,sit:Bool) {		
		for (i in 1...this.size) {
			var prevPoint:FlxPoint = new FlxPoint(parts[i - 1].x, parts[i - 1].y);
			var currentPoint:FlxPoint  = new FlxPoint(parts[i].x, parts[i].y);
			if (!sit && FlxGeom.vdistsqr(prevPoint, currentPoint) < step) {
				return;
			}
			var angle:Float = FlxGeom.angle(prevPoint,currentPoint);
			var newPos:FlxPoint = FlxGeom.vPoint(prevPoint, step, -angle);
			parts[i].x = newPos.x;
			parts[i].y = newPos.y;
		}
	}
	
	public function selected(x:Float, y:Float) {
		return x > parts[0].x && x <= parts[0].x + 20 && y > parts[0].y && y <= parts[0].y + 20 ;
	}
	
	
}

enum CatState {
		  Walking;
		  Sitting;
		  Sit;
	}