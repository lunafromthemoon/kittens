package;
import flixel.FlxSprite;

/**
 * ...
 * @author LunaFromTheMoon
 */
class Bed extends FlxSprite 
{

	public function new(x:Int,y:Int) 
	{
		super(x, y, AssetPaths.bed1__png);
		this.scale.set(0.8, 0.8);
		this.updateHitbox();
	}
	
}