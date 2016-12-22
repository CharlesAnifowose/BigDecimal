/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
/**
 * @author Elena Semukhina
 */
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertFalse;
import org.flexunit.asserts.AssertTrue;

/**
 * Class:  BigDecimal
 * Methods: abs, compareTo, equals, hashCode,
 * max, min, negate, signum
 */
class BigDecimalCompareTest
{
    @:meta(Test())

    /**
     * Abs() of a negative BigDecimal
     */
    public function testAbsNeg() : Void
    {
        var a : String = "-123809648392384754573567356745735.63567890295784902768787678287E+21";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "123809648392384754573567356745735635678902957849027687.87678287";
        Assert.areEqual(result, aNumber.abs().toCanonicalString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Abs() of a positive BigDecimal
     */
    public function testAbsPos() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E+21";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "123809648392384754573567356745735635678902957849027687.87678287";
        Assert.areEqual(result, aNumber.abs().toCanonicalString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Abs(MathContext) of a negative BigDecimal
     */
    public function testAbsMathContextNeg() : Void
    {
        var a : String = "-123809648392384754573567356745735.63567890295784902768787678287E+21";
        var aNumber : BigDecimal = new BigDecimal(a);
        var precision : Int = 15;
        //    var rm:RoundingMode = RoundingMode.HALF_DOWN;
        var mc : MathContext = new MathContext(precision, false, MathContext.ROUND_HALF_DOWN);
        var result : String = "1.23809648392385E+53";
        var resScale : Int = -39;
        var res : BigDecimal = aNumber.abs(mc);
        Assert.areEqual(result, res.toCanonicalString());  // incorrect value
        Assert.areEqual(resScale, res.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Abs(MathContext) of a positive BigDecimal
     */
    public function testAbsMathContextPos() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E+21";
        var aNumber : BigDecimal = new BigDecimal(a);
        var precision : Int = 41;
        //    var rm:RoundingMode = RoundingMode.HALF_EVEN;
        var mc : MathContext = new MathContext(precision, false, MathContext.ROUND_HALF_EVEN);
        var result : String = "1.2380964839238475457356735674573563567890E+53";
        var resScale : Int = -13;
        var res : BigDecimal = aNumber.abs(mc);
        Assert.areEqual(result, res.toCanonicalString());  // incorrect value
        Assert.areEqual(resScale, res.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Compare to a number of an equal scale
     */
    public function testCompareEqualScale1() : Void
    {
        var a : String = "12380964839238475457356735674573563567890295784902768787678287";
        var aScale : Int = 18;
        var b : String = "4573563567890295784902768787678287";
        var bScale : Int = 18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : Int = 1;
        Assert.areEqual(result, aNumber.compareTo(bNumber));  // incorrect result
    }
    
    @:meta(Test())

    /**
     * Compare to a number of an equal scale
     */
    public function testCompareEqualScale2() : Void
    {
        var a : String = "12380964839238475457356735674573563567890295784902768787678287";
        var aScale : Int = 18;
        var b : String = "4573563923487289357829759278282992758247567890295784902768787678287";
        var bScale : Int = 18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : Int = -1;
        Assert.areEqual(result, aNumber.compareTo(bNumber));  // incorrect result
    }
    
    @:meta(Test())

    /**
     * Compare to a number of an greater scale
     */
    public function testCompareGreaterScale1() : Void
    {
        var a : String = "12380964839238475457356735674573563567890295784902768787678287";
        var aScale : Int = 28;
        var b : String = "4573563567890295784902768787678287";
        var bScale : Int = 18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : Int = 1;
        Assert.areEqual(result, aNumber.compareTo(bNumber));  // incorrect result
    }
    
    @:meta(Test())

    /**
     * Compare to a number of an greater scale
     */
    public function testCompareGreaterScale2() : Void
    {
        var a : String = "12380964839238475457356735674573563567890295784902768787678287";
        var aScale : Int = 48;
        var b : String = "4573563567890295784902768787678287";
        var bScale : Int = 2;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : Int = -1;
        Assert.areEqual(result, aNumber.compareTo(bNumber));  // incorrect result
    }
    
    @:meta(Test())

    /**
     * Compare to a number of an less scale
     */
    public function testCompareLessScale1() : Void
    {
        var a : String = "12380964839238475457356735674573563567890295784902768787678287";
        var aScale : Int = 18;
        var b : String = "4573563567890295784902768787678287";
        var bScale : Int = 28;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : Int = 1;
        Assert.areEqual(result, aNumber.compareTo(bNumber));  // incorrect result
    }
    
    @:meta(Test())

    /**
     * Compare to a number of an less scale
     */
    public function testCompareLessScale2() : Void
    {
        var a : String = "12380964839238475457356735674573";
        var aScale : Int = 36;
        var b : String = "45735635948573894578349572001798379183767890295784902768787678287";
        var bScale : Int = 48;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var result : Int = -1;
        Assert.areEqual(result, aNumber.compareTo(bNumber));  // incorrect result
    }
    
    @:meta(Test())

    /**
     * Equals() for unequal BigDecimals
     */
    public function testEqualsUnequal1() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = -24;
        var b : String = "7472334223847623782375469293018787918347987234564568";
        var bScale : Int = 13;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        Assert.isFalse(aNumber.equals(bNumber));
    }
    
    @:meta(Test())

    /**
     * Equals() for unequal BigDecimals
     */
    public function testEqualsUnequal2() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = -24;
        var b : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 13;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        Assert.isFalse(aNumber.equals(bNumber));
    }
    
    @:meta(Test())

    /**
     * Equals() for unequal BigDecimals
     */
    public function testEqualsUnequal3() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = -24;
        var b : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.isFalse(aNumber.equals(b));
    }
    
    @:meta(Test())

    /**
     * equals() for equal BigDecimals
     */
    public function testEqualsEqual() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = -24;
        var b : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var bScale : Int = -24;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        // todo was assertEquals(aNumber, bNumber);
        Assert.isTrue(aNumber.equals(bNumber));
    }
    
    @:meta(Test())

    /**
     * equals() for equal BigDecimals
     */
    public function testEqualsNull() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = -24;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.isFalse(aNumber.equals(null));
    }
    
    //    [Test]
    //    /**
    //     * hashCode() for equal BigDecimals
    //     */
    //    public function testHashCodeEqual():void {
    //        var a:String = "92948782094488478231212478987482988429808779810457634781384756794987";
    //        var aScale:int = -24;
    //        var b:String = "92948782094488478231212478987482988429808779810457634781384756794987";
    //        var bScale:int = -24;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
    //        assertEquals("incorrect value", aNumber.hashCode(), bNumber.hashCode());
    //    }
    
    //    [Test]
    //    /**
    //     * hashCode() for unequal BigDecimals
    //     */
    //    public function testHashCodeUnequal():void {
    //        var a:String = "8478231212478987482988429808779810457634781384756794987";
    //        var aScale:int = 41;
    //        var b:String = "92948782094488478231212478987482988429808779810457634781384756794987";
    //        var bScale:int = -24;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
    //        assertTrue("incorrect value", aNumber.hashCode() != bNumber.hashCode());
    //    }
    
    @:meta(Test())

    /**
     * max() for equal BigDecimals
     */
    public function testMaxEqual() : Void
    {
        var a : String = "8478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var b : String = "8478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 41;
        var c : String = "8478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.max(bNumber));
        Assert.isTrue(cNumber.equals(aNumber.max(bNumber)));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * max() for unequal BigDecimals
     */
    public function testMaxUnequal1() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 24;
        var b : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 41;
        var c : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 24;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.max(bNumber));
        Assert.isTrue(cNumber.equals(aNumber.max(bNumber)));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * max() for unequal BigDecimals
     */
    public function testMaxUnequal2() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var b : String = "94488478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 41;
        var c : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.max(bNumber));
        Assert.isTrue(cNumber.equals(aNumber.max(bNumber)));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * min() for equal BigDecimals
     */
    public function testMinEqual() : Void
    {
        var a : String = "8478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var b : String = "8478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 41;
        var c : String = "8478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.min(bNumber));
        Assert.isTrue(cNumber.equals(aNumber.min(bNumber)));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * min() for unequal BigDecimals
     */
    public function testMinUnequal1() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 24;
        var b : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 41;
        var c : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.min(bNumber));
        Assert.isTrue(cNumber.equals(aNumber.min(bNumber)));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * min() for unequal BigDecimals
     */
    public function testMinUnequal2() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var b : String = "94488478231212478987482988429808779810457634781384756794987";
        var bScale : Int = 41;
        var c : String = "94488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(b, bScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.min(bNumber));
        Assert.isTrue(cNumber.equals(aNumber.min(bNumber)));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * plus() for a positive BigDecimal
     */
    public function testPlusPositive() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var c : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.plus());
        Assert.isTrue(cNumber.equals(aNumber.plus()));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * plus(MathContext) for a positive BigDecimal
     */
    public function testPlusMathContextPositive() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var precision : Int = 37;
        //    var rm:RoundingMode = RoundingMode.FLOOR;
        var mc : MathContext = new MathContext(precision, false, MathContext.ROUND_FLOOR);
        var c : String = "929487820944884782312124789.8748298842";
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var res : BigDecimal = aNumber.plus(mc);
        Assert.areEqual(c, res.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, res.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * plus() for a negative BigDecimal
     */
    public function testPlusNegative() : Void
    {
        var a : String = "-92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var c : String = "-92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.plus());
        Assert.isTrue(cNumber.equals(aNumber.plus()));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * plus(MathContext) for a negative BigDecimal
     */
    public function testPlusMathContextNegative() : Void
    {
        var a : String = "-92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 49;
        var precision : Int = 46;
        //    var rm:RoundingMode = RoundingMode.CEILING;
        var mc : MathContext = new MathContext(precision, false, MathContext.ROUND_CEILING);
        var c : String = "-9294878209448847823.121247898748298842980877981";
        var cScale : Int = 27;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var res : BigDecimal = aNumber.plus(mc);
        Assert.areEqual(c, res.toCanonicalString());  // incorrect value
        Assert.areEqual(cScale, res.scale());  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * negate() for a positive BigDecimal
     */
    public function testNegatePositive() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var c : String = "-92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.negate());
        Assert.isTrue(cNumber.equals(aNumber.negate()));  // incorrect value
    }
    
    // todo result is -929487820944884782312124789.8748298843
    //    [Test]
    //    /**
    //     * negate(MathContext) for a positive BigDecimal
    //     */
    //    public function testNegateMathContextPositive():void
    //    {
    //        var a:String = "92948782094488478231212478987482988429808779810457634781384756794987";
    //        var aScale:int = 41;
    //        var precision:int = 37;
    ////    var rm:RoundingMode = RoundingMode.FLOOR;
    //        var mc:MathContext = new MathContext(precision, MathContext.NOTATION_SCIENTIFIC, false, MathContext.ROUND_FLOOR);
    //        var c:String = "-929487820944884782312124789.8748298842";
    //        var cScale:int = 10;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var res:BigDecimal = aNumber.negate(mc);
    //        assertEquals("incorrect value", c, res.toString());
    //        assertEquals("incorrect scale", cScale, res.scale());
    //    }
    
    @:meta(Test())

    /**
     * negate() for a negative BigDecimal
     */
    public function testNegateNegative() : Void
    {
        var a : String = "-92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var c : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var cScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var cNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(c, cScale);
        // todo was assertEquals("incorrect value", cNumber, aNumber.negate());
        Assert.isTrue(cNumber.equals(aNumber.negate()));  // incorrect value
    }
    
    // todo result is 9294878209448847823.121247898748298842980877982
    //    [Test]
    //    /**
    //     * negate(MathContext) for a negative BigDecimal
    //     */
    //    public function testNegateMathContextNegative():void
    //    {
    //        var a:String = "-92948782094488478231212478987482988429808779810457634781384756794987";
    //        var aScale:int = 49;
    //        var precision:int = 46;
    ////    var rm:RoundingMode = RoundingMode.CEILING;
    //        var mc:MathContext = new MathContext(precision, MathContext.NOTATION_SCIENTIFIC, false, MathContext.ROUND_CEILING);
    //        var c:String = "9294878209448847823.121247898748298842980877981";
    //        var cScale:int = 27;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var res:BigDecimal = aNumber.negate(mc);
    //        assertEquals("incorrect value", c, res.toString());
    //        assertEquals("incorrect scale", cScale, res.scale());
    //    }
    
    @:meta(Test())

    /**
     * signum() for a positive BigDecimal
     */
    public function testSignumPositive() : Void
    {
        var a : String = "92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.areEqual(1, aNumber.signum());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * signum() for a negative BigDecimal
     */
    public function testSignumNegative() : Void
    {
        var a : String = "-92948782094488478231212478987482988429808779810457634781384756794987";
        var aScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.areEqual(-1, aNumber.signum());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * signum() for zero
     */
    public function testSignumZero() : Void
    {
        var a : String = "0";
        var aScale : Int = 41;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.areEqual(0, aNumber.signum());  // incorrect value
    }

    public function new()
    {
    }
}

