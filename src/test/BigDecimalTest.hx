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
import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.utils.ByteArray;
import flash.utils.IExternalizable;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertFalse;
import org.flexunit.asserts.AssertTrue;
import org.flexunit.asserts.Fail;

class BigDecimalTest
{
    @:meta(Test())

    public function constructor() : Void
    {
        var r : BigDecimal = new BigDecimal("-35453");
        Assert.areEqual("-35453", r.toCanonicalString());
        
        r = new BigDecimal("0.0000023423481");
        Assert.areEqual("0.0000023423481", r.toCanonicalString());
        
        r = new BigDecimal(53049580);
        Assert.areEqual("53049580", r.toCanonicalString());
        
        r = new BigDecimal(-423);
        Assert.areEqual("-423", r.toCanonicalString());
        
        try
        {
            new BigDecimal(null);
            Assert.fail("No ArgumentError");
        }
        catch (e : ArgumentError)
        {
        }
        
        try
        {
            new BigDecimal({
                not_valid : true
            });
            Assert.fail("No ArgumentError");
        }
        catch (e : ArgumentError)
        {
        }
        
        try
        {
            new BigDecimal("0", 0, -9);
            Assert.fail("No ArgumentError");
        }
        catch (e : ArgumentError)
        {
            Assert.areEqual("Invalid offset/length: 0/-9 for string: 0", e.message);
        }
    }
    
    @:meta(Test())

    public function constructorExponentBoundaries() : Void
    {
        // Note: not quite the same as Java's which has different error messages
        // and doesn't like -ve exponents <= -2147483647
        var a : BigDecimal = new BigDecimal("1.0e2147483647");
        Assert.areEqual("1.0E+2147483647", a.toCanonicalString());
        
        try
        {
            new BigDecimal("1.0e2147483648");
            Assert.fail("Should throw NumberFormatException");
        }
        catch (e : ArgumentError)
        {
            Assert.areEqual("Exponent too large: 1.0e2147483648", e.message);
        }
        
        a = new BigDecimal("1.0e-2147483646");
        Assert.areEqual("1.0E-2147483646", a.toCanonicalString());
        
        a = new BigDecimal("1.0e-2147483647");
        Assert.areEqual("1.0E-2147483647", a.toCanonicalString());
        
        try
        {
            new BigDecimal("1.0e-2147483648");
            Assert.fail("Should throw NumberFormatException");
        }
        catch (e : ArgumentError)
        {
            Assert.areEqual("Exponent too large: 1.0e-2147483648", e.message);
        }
        
        try
        {
            new BigDecimal("1.0e-2147483649");
            Assert.fail("Should throw NumberFormatException");
        }
        catch (e : ArgumentError)
        {
            Assert.areEqual("Exponent too large: 1.0e-2147483649", e.message);
        }
    }
    
    @:meta(Test())

    public function createFromUnscaledIntInvalidParams() : Void
    {
        // Most invalid string inputs handled mostly by constructor, so only bare minimum here
        try
        {
            BigDecimal.createFromUnscaledInteger(null, 0);
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
        
        try
        {
            BigDecimal.createFromUnscaledInteger("234e3gh", 0);
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }  // Specific to this method  
        
        
        
        try
        {
            BigDecimal.createFromUnscaledInteger("1.234", 5);
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {
            Assert.areEqual("The unscaledValue already has a scale: 1.234", e.message);
        }
    }
    
    @:meta(Test())

    public function toPlainStringDoesNotIncludeZeroPaddingWhenNumberZero() : Void
    {
        var a : BigDecimal = new BigDecimal("0.0e3");
        Assert.areEqual(-2, a.scale());
        Assert.areEqual("0E+2", a.toCanonicalString());
        Assert.areEqual("0", a.toPlainString());
        
        var b : BigDecimal = new BigDecimal("000");
        Assert.areEqual(0, b.scale());
        Assert.areEqual("0", b.toCanonicalString());
        Assert.areEqual("0", b.toPlainString());
    }
    
    @:meta(Test())

    public function add() : Void
    {
        var a : BigDecimal = new BigDecimal("555.50");
        var b : BigDecimal = new BigDecimal("45.55");
        
        total = a.add(b);
        Assert.areEqual("601.05", total.toCanonicalString());
        
        var c : BigDecimal = new BigDecimal("0.15015");
        var d : BigDecimal = new BigDecimal("0.34567");
        var e : BigDecimal = new BigDecimal("0.26897");
        
        var total : BigDecimal = c.add(d).add(e);
        
        Assert.areEqual(0.76479, total.numberValue());
        total = total.setScale(3, MathContext.ROUND_HALF_UP);
        Assert.areEqual(0.765, total.numberValue());
    }
    
    @:meta(Test())

    public function addWithContext() : Void
    {
        var a : BigDecimal = new BigDecimal("12333454e45");
        var b : BigDecimal = new BigDecimal("123e460");
        var mc : MathContext = new MathContext(100);
        var total : BigDecimal = a.add(b, mc);
        Assert.areEqual("1.230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000E+462", total.toCanonicalString());
    }
    
    @:meta(Test())

    public function addToZero() : Void
    {
        var a : BigDecimal = new BigDecimal("10.4");
        
        var r : BigDecimal = BigDecimal.ZERO.add(a);
        Assert.areEqual("10.4", r.toPlainString());
        
        r = a.add(BigDecimal.ZERO);
        Assert.areEqual("10.4", r.toPlainString());
    }
    
    @:meta(Test())

    public function subtract() : Void
    {
        var a : BigDecimal = new BigDecimal("555.50");
        var b : BigDecimal = new BigDecimal("45.55");
        
        var total : BigDecimal = a.subtract(b);
        Assert.areEqual("509.95", total.toCanonicalString());
        
        var c : BigDecimal = new BigDecimal("0.15015");
        var d : BigDecimal = new BigDecimal("0.34567");
        var e : BigDecimal = new BigDecimal("0.26897");
        
        total = c.subtract(d).subtract(e);
        
        Assert.areEqual(-0.46449, total.numberValue());
    }
    
    @:meta(Test())

    public function multiply() : Void
    {
        var a : BigDecimal = new BigDecimal("555.50");
        var b : BigDecimal = new BigDecimal("45.55");
        
        var total : BigDecimal = a.multiply(b);
        Assert.areEqual("25303.0250", total.toCanonicalString());
        
        var c : BigDecimal = new BigDecimal("0.15015");
        var d : BigDecimal = new BigDecimal("0.34567");
        var e : BigDecimal = new BigDecimal("0.26897");
        
        
        total = c.multiply(d).multiply(e);
        
        var number : Float = total.numberValue();
        Assert.areEqual(0.013960175213985, number);
        
        //Test envoyes par NDiaga
        number = new BigDecimal("2.3").multiply(new BigDecimal("0.95")).numberValue();
        Assert.areEqual(2.185, number);
        number = new BigDecimal("2.3").multiply(new BigDecimal("0.18")).numberValue();
        Assert.areEqual(0.414, number);
        number = new BigDecimal("2.3").multiply(new BigDecimal("0.21")).numberValue();
        Assert.areEqual(0.483, number);
        number = new BigDecimal("2.3").multiply(new BigDecimal("0.24")).numberValue();
        Assert.areEqual(0.552, number);
        number = new BigDecimal("2.3").multiply(new BigDecimal("0.29")).numberValue();
        Assert.areEqual(0.667, number);
        number = new BigDecimal("75").multiply(new BigDecimal("95")).numberValue();
        Assert.areEqual(7125, number);
        
        //Tests envoyes par Simon
        number = new BigDecimal("8490.675").multiply(new BigDecimal("100")).numberValue();
        Assert.areEqual(849067.5, number);
    }
    
    @:meta(Test())

    public function divide() : Void
    {
        var a : BigDecimal = new BigDecimal(555.50).setScale(10);
        var b : BigDecimal = new BigDecimal("45.55");
        
        var total : BigDecimal = a.divide(b);
        
        Assert.areEqual("12.1953896817", total.toCanonicalString());
        
        var c : BigDecimal = new BigDecimal("0.15015");
        c = c.setScale(31);
        var d : BigDecimal = new BigDecimal("0.34567");
        var e : BigDecimal = new BigDecimal("0.26897");
        
        total = c.divide(d).divide(e);
        
        Assert.areEqual("1.6149526889472623986174998258858", total.toCanonicalString());
    }
    
    @:meta(Test())

    public function divideInteger() : Void
    {
        var c : BigDecimal = new BigDecimal("23").divideInteger(new BigDecimal("12"));
        Assert.areEqual("1", c.toCanonicalString());
    }
    
    @:meta(Test())

    public function divideRound() : Void
    {
        var c : BigDecimal = new BigDecimal("23").divideRound(new BigDecimal("12"), MathContext.ROUND_HALF_UP);
        Assert.areEqual("2", c.toCanonicalString());
    }
    
    @:meta(Test())

    public function divideScaleRound() : Void
    {
        var a : BigDecimal = new BigDecimal("9.999999999999");
        var b : BigDecimal = new BigDecimal("3");
        
        var r : BigDecimal = a.divideScaleRound(b, 3, MathContext.ROUND_DOWN);
        Assert.areEqual("3.333", r.toCanonicalString());
        
        r = a.divideScaleRound(b, 3, MathContext.ROUND_UP);
        Assert.areEqual("3.334", r.toCanonicalString());
    }
    
    @:meta(Test())

    public function remainder() : Void
    {
        var c : BigDecimal = new BigDecimal("23").remainder(new BigDecimal("12"));
        Assert.areEqual("11", c.toCanonicalString());
    }
    
    @:meta(Test())

    public function signum() : Void
    {
        Assert.areEqual(0, new BigDecimal("0").signum());
        Assert.areEqual(0, new BigDecimal("0").abs().signum());
        
        Assert.areEqual(-1, new BigDecimal("-32.345").signum());
        Assert.areEqual(1, new BigDecimal("-32.345").abs().signum());
        //        assertEquals(1, new BigDecimal("-32.345").plus().signum());
        
        Assert.areEqual(-1, new BigDecimal("32.345").negate().signum());
    }
    
    @:meta(Test())

    public function abs() : Void
    {
        var a : BigDecimal = new BigDecimal("-555.567");
        a = a.abs();
        Assert.areEqual("555.567", a.toCanonicalString());
    }
    
    @:meta(Test())

    public function plus() : Void
    {
        var a : BigDecimal = new BigDecimal("45.3234");
        Assert.areEqual(a.toCanonicalString(), a.plus().toCanonicalString());
    }
    
    @:meta(Test())

    public function negate() : Void
    {
        var a : BigDecimal = new BigDecimal("45.3234");
        
        a = a.negate();
        Assert.areEqual("-45.3234", a.toCanonicalString());
        
        a = a.negate();
        Assert.areEqual("45.3234", a.toCanonicalString());
    }
    
    @:meta(Test())

    public function pow() : Void
    {
        var a : BigDecimal = new BigDecimal("-55.50");
        
        var total : BigDecimal = a.pow(3);
        Assert.areEqual("-170953.875000", total.toCanonicalString());
        
        try
        {
            a.pow(-3);
            Assert.fail("Should throw ArithmeticError");
        }
        catch (e : ArithmeticError)
        {
            Assert.areEqual("Invalid Operation", e.message);  // Wrong error message
        }
        
        a = new BigDecimal("213.3420000");
        var mc : MathContext = new MathContext(1, false, MathContext.ROUND_DOWN);
        var b : BigDecimal = a.pow(2, mc);
        
        Assert.areEqual("4E+4", b.toCanonicalString());
    }
    
    @:meta(Test())

    public function roundEquals() : Void
    {
        var bd : BigDecimal = (new BigDecimal(5.5)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(6)));
        bd = (new BigDecimal(2.5)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(3)));
        bd = (new BigDecimal(1.6)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(2)));
        bd = (new BigDecimal(1.1)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(1)));
        bd = (new BigDecimal(1.0)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(1)));
        bd = (new BigDecimal(-1.0)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(-1)));
        bd = (new BigDecimal(-1.1)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(-1)));
        bd = (new BigDecimal(-1.6)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(-2)));
        bd = (new BigDecimal(-2.5)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(-3)));
        bd = (new BigDecimal(-5.5)).setScale(0, MathContext.ROUND_HALF_UP);
        Assert.isTrue(bd.equals(new BigDecimal(-6)));
    }
    
    @:meta(Test())

    public function compareTo() : Void
    {
        Assert.areEqual(0, new BigDecimal("1").compareTo(new BigDecimal("1")));
        Assert.areEqual(0, new BigDecimal("1").compareTo(new BigDecimal("1.0")));
        Assert.areEqual(0, new BigDecimal("1").compareTo(new BigDecimal("1.0E0")));
        Assert.areEqual(-1, new BigDecimal("0.9").compareTo(new BigDecimal("1")));
        Assert.areEqual(1, new BigDecimal("9").compareTo(new BigDecimal("0.E+11")));
        Assert.areEqual(0, new BigDecimal("1234567890000000000000000").compareTo(new BigDecimal("1234567890.0e+15")));
    }
    
    @:meta(Test())

    public function equals() : Void
    {
        Assert.isTrue(new BigDecimal("1").equals(new BigDecimal("1")));
        Assert.isFalse(new BigDecimal("1").equals(new BigDecimal("1.0")));
        Assert.isFalse(new BigDecimal("1").equals(new BigDecimal("1.000000")));
        Assert.isFalse(new BigDecimal("1").equals(new BigDecimal("-1")));
        Assert.isFalse(new BigDecimal("1").equals(new BigDecimal("-1")));
        Assert.isFalse(new BigDecimal("0.9").equals(new BigDecimal("1")));
        Assert.isTrue(new BigDecimal(".5").equals(new BigDecimal("0.5")));
        Assert.isFalse(new BigDecimal("123456").equals(new BigDecimal("123457")));
    }
    
    @:meta(Test())

    public function scale() : Void
    {
        var a : BigDecimal = new BigDecimal("12.34");
        Assert.areEqual(2, a.scale());
        
        a = new BigDecimal("-12.34");
        Assert.areEqual(2, a.scale());
        
        a = new BigDecimal("12.345000");
        Assert.areEqual(6, a.scale());
        
        a = new BigDecimal("1e5");
        Assert.areEqual(-5, a.scale());
        
        a = new BigDecimal("1e-5");
        Assert.areEqual(5, a.scale());
        
        a = new BigDecimal("905835.90345345E450");
        Assert.areEqual(-442, a.scale());
        
        a = new BigDecimal("-905835.90345345E450");
        Assert.areEqual(-442, a.scale());
        
        a = new BigDecimal("905835.90345345E-450");
        Assert.areEqual(458, a.scale());
        
        a = new BigDecimal("-905835.90345345E-450");
        Assert.areEqual(458, a.scale());
    }
    
    @:meta(Test())

    public function intValueExact() : Void
    {
        Assert.areEqual(3341, new BigDecimal("3341").intValueExact());
        
        try
        {
            new BigDecimal("3341.00001").intValueExact();
            Assert.fail("Should throw Error");
        }
        catch (e : Error)
        {  // ok  
            
        }
    }
    
    @:meta(Test())

    public function max() : Void
    {
        var r : BigDecimal = new BigDecimal("100").max(new BigDecimal("200"));
        Assert.areEqual("200", r.toCanonicalString());
        
        r = new BigDecimal("-0.001").max(new BigDecimal("0.001"));
        Assert.areEqual("0.001", r.toCanonicalString());
    }
    
    @:meta(Test())

    public function min() : Void
    {
        var r : BigDecimal = new BigDecimal("100").min(new BigDecimal("200"));
        Assert.areEqual("100", r.toCanonicalString());
        
        r = new BigDecimal("-0.001").min(new BigDecimal("0.001"));
        Assert.areEqual("-0.001", r.toCanonicalString());
    }
    
    @:meta(Test())

    public function movePointLeft() : Void
    {
        var d : BigDecimal = new BigDecimal("43.234");
        
        var r : BigDecimal = d.movePointLeft(3);
        Assert.areEqual("0.043234", r.toCanonicalString());
        
        r = d.movePointLeft(-5);
        Assert.areEqual("4323400", r.toCanonicalString());
    }
    
    @:meta(Test())

    public function movePointRight() : Void
    {
        var d : BigDecimal = new BigDecimal("43.234");
        Assert.areEqual("43234", d.movePointRight(3).toCanonicalString());
        Assert.areEqual("0.00043234", d.movePointRight(-5).toCanonicalString());
    }
    
    @:meta(Test())

    public function strings() : Void
    {
        Assert.areEqual("0", new BigDecimal("0").toCanonicalString());
        Assert.areEqual("-54", new BigDecimal("-54").toCanonicalString());
        Assert.areEqual("20.765", new BigDecimal("20.765").toCanonicalString());
        Assert.areEqual("0.003", new BigDecimal("+0.003").toCanonicalString());
        Assert.areEqual("0.89", new BigDecimal(".89").toCanonicalString());
        Assert.areEqual("7", new BigDecimal("7.").toCanonicalString());
        Assert.areEqual("1.234E+10", new BigDecimal("1.234E10").toCanonicalString());
        Assert.areEqual("1.234E-10", new BigDecimal("1.234e-10").toCanonicalString());
        Assert.areEqual("4535.4358051100394809", new BigDecimal("4535.4358051100394809").toCanonicalString());
        Assert.areEqual("2147483647", new BigDecimal("2147483647").toCanonicalString());  // int.MAX_VALUE;  
        Assert.areEqual("-2147483648", new BigDecimal("-2147483648").toCanonicalString());  // int.MIN_VALUE;  
        Assert.areEqual("2147483648", new BigDecimal("2147483648").toCanonicalString());  // int.MAX_VALUE + 1;  
        Assert.areEqual("-2147483649", new BigDecimal("-2147483649").toCanonicalString());
    }
    
    @:meta(Test())

    public function numberValue() : Void
    {
        var v : BigDecimal = new BigDecimal("1.234E10");
        Assert.areEqual("1.234E+10", v.toCanonicalString());
        
        var n : Float = v.numberValue();
        Assert.areEqual(12340000000, n);
    }
    
    @:meta(Test())

    public function implementsIExternalizable() : Void
    {
        var a : IExternalizable = new BigDecimal("5353.2465464");
        var bs : ByteArray = new ByteArray();
        a.writeExternal(bs);
        bs.position = 0;  // reset for read  
        var b : IExternalizable = new BigDecimal();
        b.readExternal(bs);
        Assert.areEqual("5353.2465464", Std.string(b));
    }

    public function new()
    {
    }
}

