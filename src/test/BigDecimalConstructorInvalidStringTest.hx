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
import org.flexunit.asserts.Fail;

class BigDecimalConstructorInvalidStringTest
{
    @:meta(Test())

    public function emptyString() : Void
    {
        try
        {
            new BigDecimal("");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
    }
    
    @:meta(Test())

    public function signOnly() : Void
    {
        try
        {
            new BigDecimal("+");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
        
        try
        {
            new BigDecimal("-");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
    }
    
    @:meta(Test())

    public function extraDots() : Void
    {
        var strs : Array<Dynamic> = [
        "..", 
        ".1.", 
        "1..", 
        "0.1.", 
        "..1", 
        "00.1.001"
    ];
        for (str in strs)
        {
            try
            {
                new BigDecimal(str);
                Assert.fail("Should throw ArgumentError");
            }
            catch (e : ArgumentError)
            {  // pass  
                
            }
        }
    }
    
    @:meta(Test())

    public function junkAfterExponent() : Void
    {
        try
        {
            new BigDecimal("34.4534e54x");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
        
        try
        {
            new BigDecimal("1242321E-th");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
        
        try
        {
            new BigDecimal("1242321E- ");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
    }
    
    @:meta(Test())

    public function noDigits() : Void
    {
        try
        {
            new BigDecimal("-.");
            Assert.fail("Should throw ArgumentError");
        }
        catch (e : ArgumentError)
        {  // pass  
            
        }
    }

    public function new()
    {
    }
}

