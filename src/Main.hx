package;

import openfl.display.Sprite;
import BigDecimal;
import MathContext;

/**
 * ...
 * @author 
 */

class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		BigDecimal.staticInit();
		var scalePrecision:Int = 25;
		var scaleDisplay:Int = 10;
		var bd1:BigDecimal = new BigDecimal(8);
		var bd2:BigDecimal = new BigDecimal(3);
		var bd_result:BigDecimal = bd1.divideScaleRound(bd2, scalePrecision, MathContext.ROUND_HALF_UP);
		var bd_resultreversed:BigDecimal = bd_result.multiply(bd2);
		var bd_resultreversed_display = bd_resultreversed.setScale(scaleDisplay, MathContext.ROUND_HALF_UP);
		trace('Internal:', bd1.toString() + '/' + bd2.toString() );
		trace('Internal:', bd_result.toString());
		trace('Internal:', bd_resultreversed.toString());
		trace('Display:', bd_resultreversed_display.toString());
		trace('subtraction:', bd1.subtract(bd2).toString());
		
		// as3hx
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
	}
}
