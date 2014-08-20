package ;

import flixel.util.FlxPoint;
/**
 * ...
 * @author LunaFromTheMoon
 */
class FlxGeom
{

	private function new() 
	{
		
	}
	
	static public function vdistsqr(a:FlxPoint, b:FlxPoint):Float {
		//vectorial distance between point a and b
		var x:Float = b.x - a.x;
		var y:Float = b.y - a.y;
		return Math.sqrt(x * x + y * y);
	}
	
	static public function vequal(a:FlxPoint, b:FlxPoint):Bool {
		//two points are equal if their vdist is very small
		return vdistsqr(a, b) < (0.001 * 0.001);
	}
	
	static public function triarea2(a:FlxPoint, b:FlxPoint, c:FlxPoint):Float {
		//area of a triangle
		var ax:Float = b.x - a.x;
		var ay:Float = b.y - a.y;
		var bx:Float = c.x - a.x;
		var by:Float = c.y - a.y;
		return bx * ay - ax * by;
	}
	
	static public function angle(p1:FlxPoint, p2:FlxPoint ):Float {
		//angle of vector with points p1 and p2
		var xDiff:Float = p2.x - p1.x;
		var yDiff:Float = p1.y - p2.y; //-diff for reversed canvas y
		return Math.atan2(yDiff, xDiff);
	}
	
	static public function cosineTheorem(a:Float, b:Float, c:Float):Float {
		//returns angle opposed to a, where a, b and c are the lenghts of a triangle side
		//a^2 = b^2+c^2-2bc*cos(a-angle)
		var cosA:Float = (a * a - (b * b + c * c)) / ( -(2 * b * c));
		return Math.acos(cosA);
	}
	
	static public function vPoint(origin:FlxPoint, lenght:Float, angle:Float):FlxPoint {
		//returns point with given lenght and angle from origin
		var x:Float = lenght * Math.cos(angle);
		var y:Float = lenght * Math.sin(angle);
		return new FlxPoint(origin.x + x, origin.y + y);
	}
	
	static public function toDegrees(angle:Float) {
		return  angle * 180 / Math.PI;
	}
	
}