
import testing.Assert;

/**
 * Class:  BigDecimal
 * Methods: add, subtract, multiply, divide
 */
class BigDecimalArithmeticTest
{
    @:meta(Test())

    /**
     * Add two numbers of equal positive scales
     */
    public function testAddEqualScalePosPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "123121247898748373566323807282924555312937.1991359555";
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.add(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two numbers of equal positive scales using MathContext
     */
    public function testAddMathContextEqualScalePosPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "1.2313E+41";
        var cScale : Int = -37;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var mc : MathContext = new MathContext(5, false, MathContext.ROUND_UP);
        var result : BigDecimal = aNumber.add(bNumber, mc);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two numbers of equal negative scales
     */
    public function testAddEqualScaleNegNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "1.231212478987483735663238072829245553129371991359555E+61";
        var cScale : Int = -10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.add(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two numbers of equal negative scales using MathContext
     */
    public function testAddMathContextEqualScaleNegNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "1.2312E+61";
        var cScale : Int = -57;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var mc : MathContext = new MathContext(5, false, MathContext.ROUND_FLOOR);
        var result : BigDecimal = aNumber.add(bNumber, mc);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value 
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two numbers of different scales; the first is positive
     */
    public function testAddDiffScalePosNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "7472334294161400358170962860775454459810457634.781384756794987";
        var cScale : Int = 15;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.add(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two numbers of different scales using MathContext; the first is positive
     */
    public function testAddMathContextDiffScalePosNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "7.47233429416141E+45";
        var cScale : Int = -31;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var mc : MathContext = new MathContext(15, false, MathContext.ROUND_CEILING);
        var result : BigDecimal = aNumber.add(bNumber, mc);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two numbers of different scales; the first is negative
     */
    public function testAddDiffScaleNegPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "1231212478987482988429808779810457634781459480137916301878791834798.7234564568";
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.add(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Add two zeroes of different scales; the first is negative
     */
    public function testAddDiffScaleZeroZero() : Void
    {
        var a : String = "0";
        var aScale : Int = -15;
        var b : String = "0";
        var bScale : Int = 10;
        var c : String = "0E-10";
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.add(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Subtract two numbers of equal positive scales
     */
    public function testSubtractEqualScalePosPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "123121247898748224119637948679166971643339.7522230419";
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.subtract(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Subtract two numbers of equal positive scales using MathContext
     */
    public function testSubtractMathContextEqualScalePosPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "1.23121247898749E+41";
        var cScale : Int = -27;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var mc : MathContext = new MathContext(15, false, MathContext.ROUND_CEILING);
        var result : BigDecimal = aNumber.subtract(bNumber, mc);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Subtract two numbers of equal negative scales
     */
    public function testSubtractEqualScaleNegNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "1.231212478987482241196379486791669716433397522230419E+61";
        var cScale : Int = -10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.subtract(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Subtract two numbers of different scales; the first is positive
     */
    public function testSubtractDiffScalePosNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "-7472334291698975400195996883915836900189542365.218615243205013";
        var cScale : Int = 15;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.subtract(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    // todo results different
    // incorrect value - expected:<-7.4723342916989754E+45> but was:<-74.723342916989753E+44>
    //    [Test]
    //    /**
    //     * Subtract two numbers of different scales using MathContext;
    //     *  the first is positive
    //     */
    //    public function testSubtractMathContextDiffScalePosNeg():void
    //    {
    //        var a:String = "1231212478987482988429808779810457634781384756794987";
    //        var aScale:int = 15;
    //        var b:String = "747233429293018787918347987234564568";
    //        var bScale:int = -10;
    //        var c:String = "-7.4723342916989754E+45";
    //        var cScale:int = -29;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
    //        var mc:MathContext = new MathContext(17, MathContext.NOTATION_PLAIN, false, MathContext.ROUND_DOWN);
    //        var result:BigDecimal = aNumber.subtract(bNumber, mc);
    //        assertEquals("incorrect value", c, result.toString());
    //        assertEquals("incorrect scale", cScale, result.scale());
    //    }
    
    @:meta(Test())

    /**
     * Subtract two numbers of different scales; the first is negative
     */
    public function testSubtractDiffScaleNegPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "1231212478987482988429808779810457634781310033452057698121208165201.2765435432";
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.subtract(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Subtract two numbers of different scales using MathContext;
     *  the first is negative
     */
    public function testSubtractMathContextDiffScaleNegPos() : Void
    {
        var a : String = "986798656676789766678767876078779810457634781384756794987";
        var aScale : Int = -15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 40;
        var c : String = "9.867986566767897666787678760787798104576347813847567949870000000000000E+71";
        var cScale : Int = -2;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var mc : MathContext = new MathContext(70, false, MathContext.ROUND_HALF_DOWN);
        var result : BigDecimal = aNumber.subtract(bNumber, mc);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Multiply two numbers of positive scales
     */
    public function testMultiplyScalePosPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "92000312286217574978643009574114545567010139156902666284589309.1880727173060570190220616";
        var cScale : Int = 25;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.multiply(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Multiply two numbers of positive scales using MathContext
     */
    public function testMultiplyMathContextScalePosPos() : Void
    {
        var a : String = "97665696756578755423325476545428779810457634781384756794987";
        var aScale : Int = -25;
        var b : String = "87656965586786097685674786576598865";
        var bScale : Int = 10;
        var c : String = "8.561078619600910561431314228543672720908E+108";
        var cScale : Int = -69;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var mc : MathContext = new MathContext(40, false, MathContext.ROUND_HALF_DOWN);
        var result : BigDecimal = aNumber.multiply(bNumber, mc);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Multiply two numbers of negative scales
     */
    public function testMultiplyEqualScaleNegNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "9.20003122862175749786430095741145455670101391569026662845893091880727173060570190220616E+111";
        var cScale : Int = -25;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.multiply(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Multiply two numbers of different scales
     */
    public function testMultiplyDiffScalePosNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 10;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = -10;
        var c : String = "920003122862175749786430095741145455670101391569026662845893091880727173060570190220616";
        var cScale : Int = 0;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.multiply(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    // todo results differnt
    // incorrect value - expected:<7.3801839465418518653942222612429081498248509257207477E+68> but was:<7.3801839465418518653942222612429081498248509257207476E+68>
    //    [Test]
    //    /**
    //     * Multiply two numbers of different scales using MathContext
    //     */
    //    public function testMultiplyMathContextDiffScalePosNeg():void
    //    {
    //        var a:String = "987667796597975765768768767866756808779810457634781384756794987";
    //        var aScale:int = 100;
    //        var b:String = "747233429293018787918347987234564568";
    //        var bScale:int = -70;
    //        var c:String = "7.3801839465418518653942222612429081498248509257207477E+68";
    //        var cScale:int = -16;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
    //        var mc:MathContext = new MathContext(53, MathContext.NOTATION_PLAIN, false, MathContext.ROUND_HALF_UP);
    //        var result:BigDecimal = aNumber.multiply(bNumber, mc);
    //        assertEquals("incorrect value", c, result.toString());
    //        assertEquals("incorrect scale", cScale, result.scale());
    //    }
    
    @:meta(Test())

    /**
     * Multiply two numbers of different scales
     */
    public function testMultiplyDiffScaleNegPos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var c : String = "9.20003122862175749786430095741145455670101391569026662845893091880727173060570190220616E+91";
        var cScale : Int = -5;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : BigDecimal = aNumber.multiply(bNumber);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    // todo results different
    // incorrect value - expected:<3.6521591193960361339707130098174381429788164316E+98> but was:<3.6521591193960361339707130098174381429788164315E+98>
    //    [Test]
    //    /**
    //     * Multiply two numbers of different scales using MathContext
    //     */
    //    public function testMultiplyMathContextDiffScaleNegPos():void
    //    {
    //        var a:String = "488757458676796558668876576576579097029810457634781384756794987";
    //        var aScale:int = -63;
    //        var b:String = "747233429293018787918347987234564568";
    //        var bScale:int = 63;
    //        var c:String = "3.6521591193960361339707130098174381429788164316E+98";
    //        var cScale:int = -52;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
    //        var mc:MathContext = new MathContext(47, MathContext.NOTATION_PLAIN, false, MathContext.ROUND_HALF_UP);
    //        var result:BigDecimal = aNumber.multiply(bNumber, mc);
    //        assertEquals("incorrect value", c, result.toString());
    //        assertEquals("incorrect scale", cScale, result.scale());
    //    }
    
    @:meta(Test())

    /**
     * pow(int)
     */
    public function testPow() : Void
    {
        var a : String = "123121247898748298842980";
        var aScale : Int = 10;
        var exp : Int = 10;
        var c : String = "8004424019039195734129783677098845174704975003788210729597" +
        "4875206425711159855030832837132149513512555214958035390490" +
        "798520842025826.594316163502809818340013610490541783276343" +
        "6514490899700151256484355936102754469438371850240000000000";
        var cScale : Int = 100;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var result : BigDecimal = aNumber.pow(exp);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * pow(0)
     */
    public function testPow0() : Void
    {
        var a : String = "123121247898748298842980";
        var aScale : Int = 10;
        var exp : Int = 0;
        var c : String = "1";
        var cScale : Int = 0;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var result : BigDecimal = aNumber.pow(exp);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * ZERO.pow(0)
     */
    public function testZeroPow0() : Void
    {
        var c : String = "1";
        var cScale : Int = 0;
        var result : BigDecimal = BigDecimal.ZERO.pow(0);
        Assert.areEqual(c, result.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, result.scale());  // incorrect scale
    }
    
    // todo results different
    // incorrect value - expected:<8.0044E+130> but was:<8.0036E+130>
    //    [Test]
    //    /**
    //     * pow(int, MathContext)
    //     */
    //    public function testPowMathContext():void
    //    {
    //        var a:String = "123121247898748298842980";
    //        var aScale:int = 10;
    //        var exp:int = 10;
    //        var c:String = "8.0044E+130";
    //        var cScale:int = -126;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var mc:MathContext = new MathContext(5, MathContext.NOTATION_PLAIN, false, MathContext.ROUND_HALF_UP);
    //        var result:BigDecimal = aNumber.pow(exp, mc);
    //        assertEquals("incorrect value", c, result.toString());
    //        assertEquals("incorrect scale", cScale, result.scale());
    //    }
    
    @:meta(Test())

    /**
     * Divide by zero
     */
    public function testDivideByZero() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 15;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = new BigDecimal(0);
        try
        {
            aNumber.divide(bNumber);
            Assert.fail("ArithmeticException has not been caught");
        }
        catch (e : ArithmeticError)
        {
            Assert.areEqual("Division by zero", e.message);  // Improper exception message
        }
    }
    
    @:meta(Test())

    /**
     * Divide with ROUND_UNNECESSARY
     */
    public function testDivideExceptionRM() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 15;
        var b : String = "747233429293018787918347987234564568";
        var bScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        try
        {
            aNumber.divide(bNumber, MathContext.roundUnnecessary());
            Assert.fail("ArithmeticException has not been caught");
        }
        catch (e : ArithmeticError)
        {
            Assert.areEqual("Rounding necessary", e.message);  // Improper exception message
        }
    }

    public function new()
    {
    }
}

