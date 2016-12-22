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
import org.flexunit.asserts.AssertTrue;
import org.flexunit.asserts.Fail;

/**
 * Class:  java.math.BigDecimal
 * Methods: movePointLeft, movePointRight, scale, setScale, unscaledValue *
 */
class BigDecimalScaleOperationsTest
{
    @:meta(Test())

    /**
     * Check the default scale
     */
    public function testScaleDefault() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var cScale : Int = 0;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a);
        Assert.isTrue(aNumber.scale() == cScale);  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Check a negative scale
     */
    public function testScaleNeg() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = -10;
        var cScale : Int = -10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.isTrue(aNumber.scale() == cScale);  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Check a positive scale
     */
    public function testScalePos() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 10;
        var cScale : Int = 10;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.isTrue(aNumber.scale() == cScale);  // incorrect scale
    }
    
    @:meta(Test())

    /**
     * Check the zero scale
     */
    public function testScaleZero() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 0;
        var cScale : Int = 0;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        Assert.isTrue(aNumber.scale() == cScale);  // incorrect scale
    }
    
    // todo granite's BigDecimal has unscaledValue, consider adding this
    //    [Test]
    //    /**
    //     * Check the unscaled value
    //     */
    //    public function testUnscaledValue():void {
    //        var a:String = "1231212478987482988429808779810457634781384756794987";
    //        var aScale:int = 100;
    //        var bNumber:BigInteger = new BigInteger(a);
    //        var aNumber:BigDecimal = new BigDecimal(bNumber, aScale);
    //        assertTrue("incorrect unscaled value", aNumber.unscaledValue().equals(bNumber));
    //    }
    
    @:meta(Test())

    /**
     * Set a greater new scale
     */
    public function testSetScaleGreater() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 18;
        var newScale : Int = 28;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = aNumber.setScale(newScale);
        Assert.isTrue(bNumber.scale() == newScale);  // incorrect scale
        Assert.areEqual(0, bNumber.compareTo(aNumber));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Set a less new scale; this.scale == 8; newScale == 5.
     */
    public function testSetScaleLess() : Void
    {
        var a : String = "2.345726458768760000E+10";
        var newScale : Int = 5;
        var aNumber : BigDecimal = new BigDecimal(a);
        var bNumber : BigDecimal = aNumber.setScale(newScale);
        Assert.isTrue(bNumber.scale() == newScale);  // incorrect scale
        Assert.areEqual(0, bNumber.compareTo(aNumber));  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Verify an exception when setting a new scale
     */
    public function testSetScaleException() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 28;
        var newScale : Int = 18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        try
        {
            aNumber.setScale(newScale);
            Assert.fail("ArithmeticException has not been caught");
        }
        catch (e : ArithmeticError)
        {
            Assert.areEqual("Rounding necessary", e.message);  // Improper exception message
        }
    }
    
    @:meta(Test())

    /**
     * Set the same new scale
     */
    public function testSetScaleSame() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 18;
        var newScale : Int = 18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var bNumber : BigDecimal = aNumber.setScale(newScale);
        Assert.isTrue(bNumber.scale() == newScale);  // incorrect scale
        Assert.isTrue(bNumber.equals(aNumber));  // incorrect value
    }
    
    // todo granite's BigDecimal has unscaledValue, consider adding this
    //    [Test]
    //    /**
    //     * Set a new scale
    //     */
    //    public function testSetScaleRoundUp():void {
    //        var a:String = "1231212478987482988429808779810457634781384756794987";
    //        var b:String = "123121247898748298842980877981045763478139";
    //        var aScale:int = 28;
    //        var newScale:int = 18;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = aNumber.setScale(newScale, MathContext.ROUND_UP);
    //        assertTrue("incorrect scale", bNumber.scale() == newScale);
    //        assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //    }
    
    // todo granite's BigDecimal has unscaledValue, consider adding this
    //    [Test]
    //    /**
    //     * Set a new scale
    //     */
    //    public function testSetScaleRoundDown():void {
    //        var a:String = "1231212478987482988429808779810457634781384756794987";
    //        var b:String = "123121247898748298842980877981045763478138";
    //        var aScale:int = 28;
    //        var newScale:int = 18;
    //        var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //        var bNumber:BigDecimal = aNumber.setScale(newScale, MathContext.ROUND_DOWN);
    //        assertTrue("incorrect scale", bNumber.scale() == newScale);
    //        assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //    }
    
    //    /**
    //     * Set a new scale
    //     */
    //public function testSetScaleRoundCeiling():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var b:String = "123121247898748298842980877981045763478139";
    //    var aScale:int = 28;
    //    var newScale:int = 18;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    umber = aNumber.setScale(newScale, UND_CEILING);
    //    assertTrue("incorrect scale", bNumber.scale() == newScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //}
    //
    //    /**
    //     * Set a new scale
    //     */
    //public function testSetScaleRoundFloor():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var b:String = "123121247898748298842980877981045763478138";
    //    var aScale:int = 28;
    //    var newScale:int = 18;
    //    umber = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.setScale(newScale, BigDecimal.ROUND_FLOOR);
    //    assertTrue("incorrect scale", bNumber.scale() == newScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //}
    //
    //    /**
    //     * Set a new scale
    //     */
    //public function testSetScaleRoundHalfUp():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var b:String = "123121247898748298842980877981045763478138";
    //    var aScale:int = 28;
    //    var newScale:int = 18;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.setScale(newScale, BigDecimal.ROUND_HALF_UP);
    //    assertTrue("incorrect scale", bNumber.scale() == newScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //}
    //
    //    /**
    //     * Set a new scale
    //     */
    //public function testSetScaleRoundHalfDown():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var b:String = "123121247898748298842980877981045763478138";
    //    var aScale:int = 28;
    //    var newScale:int = 18;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.setScale(newScale, BigDecimal.ROUND_HALF_DOWN);
    //    assertTrue("incorrect scale", bNumber.scale() == newScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //}
    //
    //    /**
    //     * Set a new scale
    //     */
    //public function testSetScaleRoundHalfEven():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var b:String = "123121247898748298842980877981045763478138";
    //    var aScale:int = 28;
    //    var newScale:int = 18;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.setScale(newScale, BigDecimal.ROUND_HALF_EVEN);
    //    assertTrue("incorrect scale", bNumber.scale() == newScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //}
    
    @:meta(Test())

    /**
     * SetScale(int, RoundingMode)
     */
    public function testSetScaleIntRoundingMode() : Void
    {
        var a : String = "1231212478987482988429808779810457634781384756794987";
        var aScale : Int = 28;
        var newScale : Int = 18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        var result : BigDecimal = aNumber.setScale(newScale, MathContext.ROUND_HALF_EVEN);
        var res : String = "123121247898748298842980.877981045763478138";
        var resScale : Int = 18;
        Assert.areEqual(res, result.toCanonicalString());  // incorrect value
        Assert.areEqual(resScale, result.scale());  // incorrect scale
    }
    
    //    /**
    //     * Move the decimal point to the left; the shift value is positive
    //     */
    //public function testMovePointLeftPos():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var aScale:int = 28;
    //    int shift = 18;
    //    int resScale = 46;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.movePointLeft(shift);
    //    assertTrue("incorrect scale", bNumber.scale() == resScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(a));
    //}
    //
    //    /**
    //     * Move the decimal point to the left; the shift value is positive
    //     */
    //public function testMovePointLeftNeg():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var aScale:int = 28;
    //    int shift = -18;
    //    int resScale = 10;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.movePointLeft(shift);
    //    assertTrue("incorrect scale", bNumber.scale() == resScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(a));
    //}
    //
    //    /**
    //     * Move the decimal point to the right; the shift value is positive
    //     */
    //public function testMovePointRightPosGreater():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var aScale:int = 28;
    //    int shift = 18;
    //    int resScale = 10;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.movePointRight(shift);
    //    assertTrue("incorrect scale", bNumber.scale() == resScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(a));
    //}
    //
    //    /**
    //     * Move the decimal point to the right; the shift value is positive
    //     */
    //public function testMovePointRightPosLess():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var b:String = "123121247898748298842980877981045763478138475679498700";
    //    var aScale:int = 28;
    //    int shift = 30;
    //    int resScale = 0;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.movePointRight(shift);
    //    assertTrue("incorrect scale", bNumber.scale() == resScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(b));
    //}
    //
    //    /**
    //     * Move the decimal point to the right; the shift value is positive
    //     */
    //public function testMovePointRightNeg():void {
    //    var a:String = "1231212478987482988429808779810457634781384756794987";
    //    var aScale:int = 28;
    //    int shift = -18;
    //    int resScale = 46;
    //    var aNumber:BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
    //    var bNumber:BigDecimal = aNumber.movePointRight(shift);
    //    assertTrue("incorrect scale", bNumber.scale() == resScale);
    //    assertTrue("incorrect value", bNumber.unscaledValue().toString().equals(a));
    //}
    
    @:meta(Test())

    /**
     * Move the decimal point to the right when the scale overflows
     */
    public function testMovePointRightException() : Void
    {
        var a : String = "12312124789874829887348723648726347429808779810457634781384756794987";
        var aScale : Int = as3hx.Compat.INT_MAX;  //2147483647  
        var shift : Int = -18;
        var aNumber : BigDecimal = BigDecimal.createFromUnscaledInteger(a, aScale);
        try
        {
            aNumber.movePointRight(shift);
            Assert.fail("ArithmeticException has not been caught");
        }
        catch (e : ArithmeticError)
        {
            Assert.areEqual("Underflow", e.message);  // Improper exception message
        }
    }
    
    @:meta(Test())

    public function testMoveRightSetScaleThenLeft() : Void
    {
        var zeroEquivalent : BigDecimal = BigDecimal.ZERO;
        zeroEquivalent = zeroEquivalent.movePointLeft(1);
        zeroEquivalent = zeroEquivalent.setScale(0);
        zeroEquivalent = zeroEquivalent.movePointRight(1);
        Assert.areEqual("0", Std.string(zeroEquivalent));  // Too many zeros after scaling
    }
    
    @:meta(Test())

    public function testWithZeroSetScaleTo1Then0() : Void
    {
        var zeroEquivalent : BigDecimal = BigDecimal.ZERO;
        zeroEquivalent = zeroEquivalent.setScale(1, MathContext.ROUND_HALF_UP);
        zeroEquivalent = zeroEquivalent.setScale(0, MathContext.ROUND_HALF_UP);
        Assert.areEqual("0", Std.string(zeroEquivalent));  // Too many zeros after scaling up then down
    }

    public function new()
    {
    }
}

