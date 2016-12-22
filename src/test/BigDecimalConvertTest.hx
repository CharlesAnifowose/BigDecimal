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

/**
 * Class:  BigDecimal
 * Methods: doubleValue, floatValue, intValue, longValue,
 * valueOf, toString, toBigInteger
 */
class BigDecimalConvertTest
{
    @:meta(Test())

    /**
     * Double value of a negative BigDecimal
     */
    public function testDoubleValueNeg() : Void
    {
        var a : String = "-123809648392384754573567356745735.63567890295784902768787678287E+21";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : Float = -1.2380964839238476;E53;
        Assert.areEqual(result, aNumber.numberValue());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Double value of a positive BigDecimal
     */
    public function testDoubleValuePos() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E+21";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : Float = 1.2380964839238476;E53;
        Assert.areEqual(result, aNumber.numberValue());  // incorrect value
    }
    
    // todo result is 0 instead of +Infinity
    //    [Test]
    //    /**
    //     * Double value of a large positive BigDecimal
    //     */
    //    public function testDoubleValuePosInfinity():void
    //    {
    //        var a:String = "123809648392384754573567356745735.63567890295784902768787678287E+400";
    //        var aNumber:BigDecimal = new BigDecimal(a);
    //        var result:Number = Number.POSITIVE_INFINITY;
    //        assertEquals("incorrect value", result, aNumber.numberValue());//, 0);
    //    }
    
    // todo result is 0 instead of -Infinity
    //    [Test]
    //    /**
    //     * Double value of a large negative BigDecimal
    //     */
    //    public function testDoubleValueNegInfinity():void
    //    {
    //        var a:String = "-123809648392384754573567356745735.63567890295784902768787678287E+400";
    //        var aNumber:BigDecimal = new BigDecimal(a);
    //        var result:Number = Number.NEGATIVE_INFINITY;
    //        assertEquals("incorrect value", result, aNumber.numberValue()); //, 0);
    //    }
    
    //    [Test]
    //    /**
    //     * Double value of a small negative BigDecimal
    //     */
    //public function testDoubleValueMinusZero():void {
    //    var a:String = "-123809648392384754573567356745735.63567890295784902768787678287E-400";
    //    var aNumber:BigDecimal = new BigDecimal(a);
    //    var minusZero:long:var = -9223372036854775808L;
    //    var result:Number = aNumber.numberValue();
    //    assertTrue("incorrect value", Double.doubleToLongBits(result) == minusZero);
    //}
    
    //    [Test]
    //    /**
    //     * Double value of a small positive BigDecimal
    //     */
    //public function testDoubleValuePlusZero():void {
    //    var a:String = "123809648392384754573567356745735.63567890295784902768787678287E-400";
    //    var aNumber:BigDecimal = new BigDecimal(a);
    //    var zero:long = 0;
    //    var result:Number = aNumber.numberValue();
    //    assertTrue("incorrect value", Double.doubleToLongBits(result) == zero);
    //}
    
    //    [Test]
    //    /**
    //     * Float value of a negative BigDecimal
    //     */
    //public function testFloatValueNeg():void {
    //    var a:String: var = "-1238096483923847.6356789029578E+21";
    //    var aNumber:BigDecimal = new BigDecimal(a);
    //    var result:float = -1.2380965E36F;
    //    assertTrue("incorrect value", aNumber.floatValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * Float value of a positive BigDecimal
    //     */
    //public function testFloatValuePos():void {
    //    var a:String = "1238096483923847.6356789029578E+21";
    //    var aNumber:BigDecimal = new BigDecimal(a);
    //    var result:float = 1.2380965E36F;
    //    assertTrue("incorrect value", aNumber.floatValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * Float value of a large positive BigDecimal
    //     */
    //public function testFloatValuePosInfinity():void {
    //    var a:String = "123809648373567356745735.6356789787678287E+200";
    //    var aNumber:BigDecimal = new BigDecimal(a);
    //    var result:float = Float.POSITIVE_INFINITY;
    //    assertTrue("incorrect value", aNumber.floatValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * Float value of a large negative BigDecimal
    //     */
    //public function testFloatValueNegInfinity():void {
    //    var a: String = "-123809648392384755735.63567887678287E+200";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: float = Float.NEGATIVE_INFINITY;
    //    assertTrue("incorrect value", aNumber.floatValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * Float value of a small negative BigDecimal
    //     */
    //public function testFloatValueMinusZero():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E-400";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var minusZero: int = -2147483648;
    //    var result: float = aNumber.floatValue();
    //    assertTrue("incorrect value", Float.floatToIntBits(result) == minusZero);
    //}
    
    //    [Test]
    //    /**
    //     * Float value of a small positive BigDecimal
    //     */
    //public function testFloatValuePlusZero():void {
    //    var a: String = "123809648392384754573567356745735.63567890295784902768787678287E-400";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var zero: int = 0;
    //    var result: float = aNumber.floatValue();
    //    assertTrue("incorrect value", Float.floatToIntBits(result) == zero);
    //}
    
    //    [Test]
    //    /**
    //     * Integer value of a negative BigDecimal
    //     */
    //public function testIntValueNeg():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E+21";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: int = 218520473;
    //    assertTrue("incorrect value", aNumber.intValue() == result);
    //}
    
    // todo should be possible
    //    [Test]
    //    /**
    //     * Integer value of a positive BigDecimal
    //     */
    //public function testIntValuePos():void {
    //    var a: String = "123809648392384754573567356745735.63567890295784902768787678287E+21";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: int = -218520473;
    //    assertTrue("incorrect value", aNumber.intValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * Long value of a negative BigDecimal
    //     */
    //public function testLongValueNeg():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E+21";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: long = -1246043477766677607L;
    //    assertTrue("incorrect value", aNumber.longValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * Long value of a positive BigDecimal
    //     */
    //public function testLongValuePos():void {
    //    var a: String = "123809648392384754573567356745735.63567890295784902768787678287E+21";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: long = 1246043477766677607L;
    //    assertTrue("incorrect value", aNumber.longValue() == result);
    //}
    
    //    [Test]
    //    /**
    //     * scaleByPowerOfTen(int n)
    //     */
    //public function testScaleByPowerOfTen1():void {
    //    var a: String = "1231212478987482988429808779810457634781384756794987";
    //    var aScale: int = 13;
    //    var aNumber: BigDecimal = new BigDecimal(new BigInteger(a), aScale);
    //    var result: BigDecimal = aNumber.scaleByPowerOfTen(10);
    //    var res: String = "1231212478987482988429808779810457634781384756794.987";
    //    int resScale = 3;
    //    assertEquals("incorrect value", res, result.toString());
    //    assertEquals("incorrect scale", resScale, result.scale());
    //}
    
    //    [Test]
    //    /**
    //     * scaleByPowerOfTen(int n)
    //     */
    //public function testScaleByPowerOfTen2():void {
    //    var a: String = "1231212478987482988429808779810457634781384756794987";
    //    var aScale: int = -13;
    //    var aNumber: BigDecimal = new BigDecimal(new BigInteger(a), aScale);
    //    var result: BigDecimal = aNumber.scaleByPowerOfTen(10);
    //    var res: String = "1.231212478987482988429808779810457634781384756794987E+74";
    //    var resScale: int = -23;
    //    assertEquals("incorrect value", res, result.toString());
    //    assertEquals("incorrect scale", resScale, result.scale());
    //}
    
    //    [Test]
    //    /**
    //     * Convert a positive BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerPos1():void {
    //    var a: String = "123809648392384754573567356745735.63567890295784902768787678287E+21";
    //    var bNumber: BigInteger = new BigInteger("123809648392384754573567356745735635678902957849027687");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * Convert a positive BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerPos2():void {
    //    var a: String = "123809648392384754573567356745735.63567890295784902768787678287E+15";
    //    var bNumber: BigInteger = new BigInteger("123809648392384754573567356745735635678902957849");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * Convert a positive BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerPos3():void {
    //    var a: String = "123809648392384754573567356745735.63567890295784902768787678287E+45";
    //    var bNumber: BigInteger = new BigInteger("123809648392384754573567356745735635678902957849027687876782870000000000000000");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * Convert a negative BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerNeg1():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E+21";
    //    var bNumber: BigInteger = new BigInteger("-123809648392384754573567356745735635678902957849027687");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * Convert a negative BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerNeg2():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E+15";
    //    var bNumber: BigInteger = new BigInteger("-123809648392384754573567356745735635678902957849");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * Convert a negative BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerNeg3():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E+45";
    //    var bNumber: BigInteger = new BigInteger("-123809648392384754573567356745735635678902957849027687876782870000000000000000");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * Convert a small BigDecimal to BigInteger
    //     */
    //public function testToBigIntegerZero():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E-500";
    //    var bNumber: BigInteger = new BigInteger("0");
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var result: BigInteger = aNumber.toBigInteger();
    //    assertTrue("incorrect value", result.equals(bNumber));
    //}
    
    //    [Test]
    //    /**
    //     * toBigIntegerExact()
    //     */
    //public function testToBigIntegerExact1():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E+45";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    var res: String = "-123809648392384754573567356745735635678902957849027687876782870000000000000000";
    //    var result: BigInteger = aNumber.toBigIntegerExact();
    //    assertEquals("incorrect value", res, result.toString());
    //}
    
    //    [Test]
    //    /**
    //     * toBigIntegerExact()
    //     */
    //public function testToBigIntegerExactException():void {
    //    var a: String = "-123809648392384754573567356745735.63567890295784902768787678287E-10";
    //    var aNumber: BigDecimal = new BigDecimal(a);
    //    try {
    //        aNumber.toBigIntegerExact();
    //        fail("java.lang.ArithmeticException has not been thrown");
    //    } catch (java.lang.ArithmeticException e) {
    //        return;
    //    }
    //}
    
    @:meta(Test())

    /**
     * Convert a positive BigDecimal to an engineering string representation
     */
    public function testToEngineeringStringPos() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E-501";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "123.80964839238475457356735674573563567890295784902768787678287E-471";
        Assert.areEqual(result, aNumber.toEngineeringString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a negative BigDecimal to an engineering string representation
     */
    public function testToEngineeringStringNeg() : Void
    {
        var a : String = "-123809648392384754573567356745735.63567890295784902768787678287E-501";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "-123.80964839238475457356735674573563567890295784902768787678287E-471";
        Assert.areEqual(result, aNumber.toEngineeringString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a negative BigDecimal to an engineering string representation
     */
    public function testToEngineeringStringZeroPosExponent() : Void
    {
        var a : String = "0.0E+16";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "0E+15";
        Assert.areEqual(result, aNumber.toEngineeringString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a negative BigDecimal to an engineering string representation
     */
    public function testToEngineeringStringZeroNegExponent() : Void
    {
        var a : String = "0.0E-16";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "0.00E-15";
        Assert.areEqual(result, aNumber.toEngineeringString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a negative BigDecimal with a negative exponent to a plain string
     * representation; scale == 0.
     */
    public function testToPlainStringNegNegExp() : Void
    {
        var a : String = "-123809648392384754573567356745735.63567890295784902768787678287E-100";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "-0.000000000000000000000000000000000000000000000000000000000000000000012380964839238475457356735674573563567890295784902768787678287";
        Assert.areEqual(result, aNumber.toPlainString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a negative BigDecimal with a positive exponent
     * to a plain string representation;
     * scale == 0.
     */
    public function testToPlainStringNegPosExp() : Void
    {
        var a : String = "-123809648392384754573567356745735.63567890295784902768787678287E100";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "-1238096483923847545735673567457356356789029578490276878767828700000000000000000000000000000000000000000000000000000000000000000000000";
        Assert.areEqual(result, aNumber.toPlainString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a positive BigDecimal with a negative exponent
     * to a plain string representation;
     * scale == 0.
     */
    public function testToPlainStringPosNegExp() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E-100";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "0.000000000000000000000000000000000000000000000000000000000000000000012380964839238475457356735674573563567890295784902768787678287";
        Assert.areEqual(result, aNumber.toPlainString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a negative BigDecimal with a negative exponent
     * to a plain string representation;
     * scale == 0.
     */
    public function testToPlainStringPosPosExp() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E+100";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "1238096483923847545735673567457356356789029578490276878767828700000000000000000000000000000000000000000000000000000000000000000000000";
        Assert.areEqual(result, aNumber.toPlainString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a BigDecimal to a string representation;
     * scale == 0.
     */
    public function testToStringZeroScale() : Void
    {
        var a : String = "-123809648392384754573567356745735635678902957849027687876782870";
        //        var aNumber:BigDecimal = new BigDecimal(new BigInteger(a));
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "-123809648392384754573567356745735635678902957849027687876782870";
        Assert.areEqual(result, aNumber.toCanonicalString());  // incorrect value
    }
    
    @:meta(Test())

    /**
     * Convert a positive BigDecimal to a string representation
     */
    public function testToStringPos() : Void
    {
        var a : String = "123809648392384754573567356745735.63567890295784902768787678287E-500";
        var aNumber : BigDecimal = new BigDecimal(a);
        var result : String = "1.2380964839238475457356735674573563567890295784902768787678287E-468";
        Assert.areEqual(result, aNumber.toCanonicalString());  // incorrect value
    }

    public function new()
    {
    }
}

