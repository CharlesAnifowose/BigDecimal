package;

class EcmaHX_Compat
{

	public static function arraySplice(arr:Array<Dynamic>, pos:Int, len:Int, insertion:Null<Array<Dynamic>>=null):Void
	{
		arr.splice(pos, len);
		if (insertion != null) {
			for (i in 0...insertion.length) {
				arr.insert(pos + i, insertion[i]);
			}
		}
	}
	
	
}