import openfl.errors.ArgumentError;
import openfl.errors.Error;
// IExternalizable

//##header 1189099963000 FOUNDATION
/* Generated from 'BigDecimal.nrx' 8 Sep 2000 11:10:50 [v2.00] */
/* Options: Binary Comments Crossref Format Java Logo Strictargs Strictcase Trace2 Verbose3 */
/* ------------------------------------------------------------------ */
/* BigDecimal -- Decimal arithmetic for Java */
/* ------------------------------------------------------------------ */
/* Copyright IBM Corporation, 1996-2006. All Rights Reserved. */
/* */
/* The BigDecimal class provides immutable arbitrary-precision */
/* floating point (including integer) decimal numbers. */
/* */
/* As the numbers are decimal, there is an exact correspondence */
/* between an instance of a BigDecimal object and its String */
/* representation; the BigDecimal class provides direct conversions */
/* to and from String and character array objects, and well as */
/* conversions to and from the Java primitive types (which may not */
/* be exact). */
/* ------------------------------------------------------------------ */
/* Notes: */
/* */
/* 1. A BigDecimal object is never changed in value once constructed; */
/* this avoids the need for locking. Note in particular that the */
/* mantissa array may be shared between many BigDecimal objects, */
/* so that once exposed it must not be altered. */
/* */
/* 2. This class looks at MathContext class fields directly (for */
/* performance). It must not and does not change them. */
/* */
/* 3. Exponent checking is delayed until finish(), as we know */
/* intermediate calculations cannot cause 31-bit overflow. */
/* [This assertion depends on MAX_DIGITS in MathContext.] */
/* */
/* 4. Comments for the public API now follow the javadoc conventions. */
/* The NetRexx -comments option is used to pass these comments */
/* through to the generated Java code (with -format, if desired). */
/* */
/* 5. System.arraycopy is faster than explicit loop as follows */
/* Mean length 4: equal */
/* Mean length 8: x2 */
/* Mean length 16: x3 */
/* Mean length 24: x4 */
/* From prior experience, we expect mean length a little below 8, */
/* but arraycopy is still the one to use, in general, until later */
/* measurements suggest otherwise. */
/* */
/* 6. 'DMSRCN' referred to below is the original (1981) IBM S/370 */
/* assembler code implementation of the algorithms below; it is */
/* now called IXXRCN and is available with the OS/390 and VM/ESA */
/* operating systems. */
/* ------------------------------------------------------------------ */
/* Change History: */
/* 1997.09.02 Initial version (derived from netrexx.lang classes) */
/* 1997.09.12 Add lostDigits checking */
/* 1997.10.06 Change mantissa to a byte array */
/* 1997.11.22 Rework power [did not prepare arguments, etc.] */
/* 1997.12.13 multiply did not prepare arguments */
/* 1997.12.14 add did not prepare and align arguments correctly */
/* 1998.05.02 0.07 packaging changes suggested by Sun and Oracle */
/* 1998.05.21 adjust remainder operator finalization */
/* 1998.06.04 rework to pass MathContext to finish() and round() */
/* 1998.06.06 change format to use round(); support rounding modes */
/* 1998.06.25 rename to BigDecimal and begin merge */
/* zero can now have trailing zeros (i.e., exp\=0) */
/* 1998.06.28 new methods: movePointXxxx, scale, toBigInteger */
/* unscaledValue, valueof */
/* 1998.07.01 improve byteaddsub to allow array reuse, etc. */
/* 1998.07.01 make null testing explicit to avoid JIT bug [Win32] */
/* 1998.07.07 scaled division [divide(BigDecimal, int, int)] */
/* 1998.07.08 setScale, faster equals */
/* 1998.07.11 allow 1E6 (no sign) <sigh>; new double/float conversion */
/* 1998.10.12 change package to com.ibm.icu.math */
/* 1998.12.14 power operator no longer rounds RHS [to match ANSI] */
/* add toBigDecimal() and BigDecimal(java.math.BigDecimal) */
/* 1998.12.29 improve byteaddsub by using table lookup */
/* 1999.02.04 lostdigits=0 behaviour rounds instead of digits+1 guard */
/* 1999.02.05 cleaner code for BigDecimal(char[]) */
/* 1999.02.06 add javadoc comments */
/* 1999.02.11 format() changed from 7 to 2 method form */
/* 1999.03.05 null pointer checking is no longer explicit */
/* 1999.03.05 simplify; changes from discussion with J. Bloch: */
/* null no longer permitted for MathContext; drop Boolean, */
/* byte, char, float, short constructor, deprecate double */
/* constructor, no blanks in string constructor, add */
/* offset and length version of char[] constructor; */
/* add valueOf(double); drop BooleanValue, charValue; */
/* add ...Exact versions of remaining convertors */
/* 1999.03.13 add toBigIntegerExact */
/* 1999.03.13 1.00 release to IBM Centre for Java Technology */
/* 1999.05.27 1.01 correct 0-0.2 bug under scaled arithmetic */
/* 1999.06.29 1.02 constructors should not allow exponent > 9 digits */
/* 1999.07.03 1.03 lost digits should not be checked if digits=0 */
/* 1999.07.06 lost digits Exception message changed */
/* 1999.07.10 1.04 more work on 0-0.2 (scaled arithmetic) */
/* 1999.07.17 improve messages from pow method */
/* 1999.08.08 performance tweaks */
/* 1999.08.15 fastpath in multiply */
/* 1999.11.05 1.05 fix problem in intValueExact [e.g., 5555555555] */
/* 1999.12.22 1.06 remove multiply fastpath, and improve performance */
/* 2000.01.01 copyright update [Y2K has arrived] */
/* 2000.06.18 1.08 no longer deprecate BigDecimal(double) */
/* ------------------------------------------------------------------ */
/**
 * The <code>BigDecimal</code> class implements immutable
 * arbitrary-precision decimal numbers. The methods of the
 * <code>BigDecimal</code> class provide operations for fixed and
 * floating point arithmetic, comparison, format conversions, and
 * hashing.
 * <p>
 * As the numbers are decimal, there is an exact correspondence between
 * an instance of a <code>BigDecimal</code> object and its
 * <code>String</code> representation; the <code>BigDecimal</code> class
 * provides direct conversions to and from <code>String</code> and
 * character array (<code>char[]</code>) objects, as well as conversions
 * to and from the Java primitive types (which may not be exact) and
 * <code>BigInteger</code>.
 * <p>
 * In the descriptions of constructors and methods in this documentation,
 * the value of a <code>BigDecimal</code> number object is shown as the
 * result of invoking the <code>toString()</code> method on the object.
 * The internal representation of a decimal number is neither defined
 * nor exposed, and is not permitted to affect the result of any
 * operation.
 * <p>
 * The floating point arithmetic provided by this class is defined by
 * the ANSI X3.274-1996 standard, and is also documented at
 * <code>http://www2.hursley.ibm.com/decimal</code>
 * <br><i>[This URL will change.]</i>
 *
 * <h3>Operator methods</h3>
 * <p>
 * Operations on <code>BigDecimal</code> numbers are controlled by a
 * {@link MathContext} object, which provides the context (precision and
 * other information) for the operation. Methods that can take a
 * <code>MathContext</code> parameter implement the standard arithmetic
 * operators for <code>BigDecimal</code> objects and are known as
 * <i>operator methods</i>. The default settings provided by the
 * constant {@link MathContext#DEFAULT} (<code>digits=9,
 * form=SCIENTIFIC, lostDigits=false, roundingMode=ROUND_HALF_UP</code>)
 * perform general-purpose floating point arithmetic to nine digits of
 * precision. The <code>MathContext</code> parameter must not be
 * <code>null</code>.
 * <p>
 * Each operator method also has a version provided which does
 * not take a <code>MathContext</code> parameter. For this version of
 * each method, the context settings used are <code>digits=0,
 * form=PLAIN, lostDigits=false, roundingMode=ROUND_HALF_UP</code>;
 * these settings perform fixed point arithmetic with unlimited
 * precision, as defined for the original BigDecimal class in Java 1.1
 * and Java 1.2.
 * <p>
 * For monadic operators, only the optional <code>MathContext</code>
 * parameter is present; the operation acts upon the current object.
 * <p>
 * For dyadic operators, a <code>BigDecimal</code> parameter is always
 * present; it must not be <code>null</code>.
 * The operation acts with the current object being the left-hand operand
 * and the <code>BigDecimal</code> parameter being the right-hand operand.
 * <p>
 * For example, adding two <code>BigDecimal</code> objects referred to
 * by the names <code>award</code> and <code>extra</code> could be
 * written as any of:
 * <p><code>
 * award.add(extra)
 * <br>award.add(extra, MathContext.DEFAULT)
 * <br>award.add(extra, acontext)
 * </code>
 * <p>
 * (where <code>acontext</code> is a <code>MathContext</code> object),
 * which would return a <code>BigDecimal</code> object whose value is
 * the result of adding <code>award</code> and <code>extra</code> under
 * the appropriate context settings.
 * <p>
 * When a <code>BigDecimal</code> operator method is used, a set of
 * rules define what the result will be (and, by implication, how the
 * result would be represented as a character string).
 * These rules are defined in the BigDecimal arithmetic documentation
 * (see the URL above), but in summary:
 * <ul>
 * <li>Results are normally calculated with up to some maximum number of
 * significant digits.
 * For example, if the <code>MathContext</code> parameter for an operation
 * were <code>MathContext.DEFAULT</code> then the result would be
 * rounded to 9 digits; the division of 2 by 3 would then result in
 * 0.666666667.
 * <br>
 * You can change the default of 9 significant digits by providing the
 * method with a suitable <code>MathContext</code> object. This lets you
 * calculate using as many digits as you need -- thousands, if necessary.
 * Fixed point (scaled) arithmetic is indicated by using a
 * <code>digits</code> setting of 0 (or omitting the
 * <code>MathContext</code> parameter).
 * <br>
 * Similarly, you can change the algorithm used for rounding from the
 * default "classic" algorithm.
 * <li>
 * In standard arithmetic (that is, when the <code>form</code> setting
 * is not <code>PLAIN</code>), a zero result is always expressed as the
 * single digit <code>'0'</code> (that is, with no sign, decimal point,
 * or exponent part).
 * <li>
 * Except for the division and power operators in standard arithmetic,
 * trailing zeros are preserved (this is in contrast to binary floating
 * point operations and most electronic calculators, which lose the
 * information about trailing zeros in the fractional part of results).
 * <br>
 * So, for example:
 * <p><code>
 * new BigDecimal("2.40").add( new BigDecimal("2")) =&gt; "4.40"
 * <br>new BigDecimal("2.40").subtract(new BigDecimal("2")) =&gt; "0.40"
 * <br>new BigDecimal("2.40").multiply(new BigDecimal("2")) =&gt; "4.80"
 * <br>new BigDecimal("2.40").divide( new BigDecimal("2"), def) =&gt; "1.2"
 * </code>
 * <p>where the value on the right of the <code>=&gt;</code> would be the
 * result of the operation, expressed as a <code>String</code>, and
 * <code>def</code> (in this and following examples) refers to
 * <code>MathContext.DEFAULT</code>).
 * This preservation of trailing zeros is desirable for most
 * calculations (including financial calculations).
 * If necessary, trailing zeros may be easily removed using division by 1.
 * <li>
 * In standard arithmetic, exponential form is used for a result
 * depending on its value and the current setting of <code>digits</code>
 * (the default is 9 digits).
 * If the number of places needed before the decimal point exceeds the
 * <code>digits</code> setting, or the absolute value of the number is
 * less than <code>0.000001</code>, then the number will be expressed in
 * exponential notation; thus
 * <p><code>
 * new BigDecimal("1e+6").multiply(new BigDecimal("1e+6"), def)
 * </code>
 * <p>results in <code>1E+12</code> instead of
 * <code>1000000000000</code>, and
 * <p><code>
 * new BigDecimal("1").divide(new BigDecimal("3E+10"), def)
 * </code>
 * <p>results in <code>3.33333333E-11</code> instead of
 * <code>0.0000000000333333333</code>.
 * <p>
 * The form of the exponential notation (scientific or engineering) is
 * determined by the <code>form</code> setting.
 * <eul>
 * <p>
 * The names of methods in this class follow the conventions established
 * by <code>java.lang.Number</code>, <code>java.math.BigInteger</code>,
 * and <code>java.math.BigDecimal</code> in Java 1.1 and Java 1.2.
 *
 * @see MathContext
 * @author Mike Cowlishaw
 * @stable ICU 2.0
 */
/** ActionScript 3 conversion (c) 2009
 *   Jean-Francois Larouche, Canada
 *
 *   To know what have been changed, just search for
 *   ActionScript in this file.
 *
 *   Constructors:
 *
 *   new BigDecimal() : Default BigDecimal to 0
 *   new BigDecimal(String) : String must be a decimal representation.
 *   new BigDecimal(int)
 *   new BigDecimal(Number)
 *
 *   This class is Immutable exactly like the Java version
 *
 *   To convert the value back:
 *   decimal.numberValue();
 *   decimal.toString()
 *
 **/
class BigDecimal //implements IExternalizable
{
    /**
     * Used by BigDecimal internally to call its own constructor with a "null" parameter.
     * Note since statics are initialized in declaration order, top to bottom,
     * this needs to come before the public constants defined with createStatic
     */
    private static var NULL : Dynamic = { };
    
    /* ----- Constants ----- */
    /* properties constant public */  // useful to others  
    /**
     * The <code>BigDecimal</code> constant "0".
     *
     * @see #ONE
     * @see #TEN
     * @stable ICU 2.0
     */
    public static var ZERO : BigDecimal = createStatic(0);  // use long as we want the int constructor  
    // .. to be able to use this, for speed
    
    /**
     * The <code>BigDecimal</code> constant "1".
     *
     * @see #TEN
     * @see #ZERO
     * @stable ICU 2.0
     */
    public static var ONE : BigDecimal = createStatic(1);  // use long as we want the int constructor  
    // .. to be able to use this, for speed
    
    /**
     * The <code>BigDecimal</code> constant "10".
     *
     * @see #ONE
     * @see #ZERO
     * @stable ICU 2.0
     */
    public static var TEN : BigDecimal = createStatic(10);
    
    /* properties constant private */  // locals  
    private static inline var ispos : Int = 1;  // ind: indicates positive (must be 1)  
    private static inline var iszero : Int = 0;  // ind: indicates zero (must be 0)  
    private static var isneg : Int = -1;  // ind: indicates negative (must be -1)  
    // [later could add NaN, +/- infinity, here]
    
    // ActionScript 3 Port
    // In AS3 there is no char, byte or native arrays
    // So lets create the int value of each char we need in the
    // algorythms
    private static var CODE_0 : Int = "0".charCodeAt(0);  // use long as we want the int constructor  
    private static var CODE_9 : Int = "9".charCodeAt(0);  // use long as we want the int constructor  
    private static var CODE_e : Int = "e".charCodeAt(0);  // use long as we want the int constructor  
    private static var CODE_E : Int = "E".charCodeAt(0);  // use long as we want the int constructor  
    private static var CODE_dot : Int = ".".charCodeAt(0);  // use long as we want the int constructor  
    private static var CODE_plus : Int = "+".charCodeAt(0);  // use long as we want the int constructor  
    private static var CODE_minus : Int = "-".charCodeAt(0);  // use long as we want the int constructor  
    
    /* properties static private */
    // Precalculated constant arrays (used by byteaddsub)
    private static var bytecar : Array<Int> = new Array<Int>();  // carry/borrow array  
    private static var bytedig : Array<Int>;  // next digit array  
	private static var staticInitPassed:Bool = false;
	public static function staticInit():Void
	{
		if (staticInitPassed == false) {
			bytedig = diginit();
			staticInitPassed = true;
		}
	}
    
    // If true, we need to explicitly set lengthened vectors extra digits to 0
    private static var vectorPadFix : Bool = needVectorPadFix();
    
    /* ----- Instance properties [all private and immutable] ----- */
    /* properties private */
    
    /**
     * The indicator. This may take the values:
     * <ul>
     * <li>ispos -- the number is positive
     * <li>iszero -- the number is zero
     * <li>isneg -- the number is negative
     * </ul>
     *
     * @serial
     */
    private var ind : Int;  // assumed undefined  
    // Note: some code below assumes IND = Sign [-1, 0, 1], at present.
    // We only need two bits for this, but use a byte [also permits
    // smooth future extension].
    
    /**
     * The value of the mantissa.
     * <p>
     * Once constructed, this may become shared between several BigDecimal
     * objects, so must not be altered.
     * <p>
     * For efficiency (speed), this is a byte array, with each byte
     * taking a value of 0 -> 9.
     * <p>
     * If the first byte is 0 then the value of the number is zero (and
     * mant.length=1, except when constructed from a plain number, for
     * example, 0.000).
     *
     * @serial
     */
    private var mant : Array<Int>;  // assumed null  
    
    /**
     * The exponent.
     * <p>
     * For fixed point arithmetic, scale is <code>-exp</code>, and can
     * apply to zero.
     *
     * Note that this property can have a value less than MinExp when
     * the mantissa has more than one digit.
     *
     * @serial
     */
    private var exp : Int = 0;
    // assumed 0
    
    /**
     * Caches toString after first built
     */
    private var string : String;
    
    /* ---------------------------------------------------------------- */
    /* Constructors */
    /* ---------------------------------------------------------------- */
    
    /**
     * Constructs a new <code>BigDecimal</code> instance from a given unscaled value
     * <code>unscaledVal</code> and a given scale. The value of this instance is
     * <code>unscaledVal</code> (<code>10^-scale</code>). The result is rounded according
     * to the specified math context.
     *
     * @param unscaledValue
     *            <code>String</code> representing the unscaled integer value of this
     *            <code>BigDecimal</code> instance.
     * @param scale
     *            scale of this <code>BigDecimal</code> instance.
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @throws ArgumentError
     *             if <code>mc.precision > 0</code> and
     *             <code>context.roundingMode == UNNECESSARY</code>
     *             and the new big decimal cannot be represented
     *             within the given precision without rounding.
     * @throws TypeError
     *             if <code>unscaledValue == null</code>.
     */
    public static function createFromUnscaledInteger(unscaledValue : String, scale : Int = 0, context : MathContext = null) : BigDecimal
    {
        var d : BigDecimal = new BigDecimal(unscaledValue);
        if (d.exp != 0 && scale != 0)
        {
            throw new ArgumentError("The unscaledValue already has a scale: " + unscaledValue);
        }
        d.exp = -scale;
        return d.plus(context);
    }
    
	
	function parseFloat(t:Dynamic):Float
	{
		return Std.parseFloat(Std.string(t));
	}
	
    /**
     * Constructs a <code>BigDecimal</code> object from the given input.
     * <p>
     * The given <code>inobject</code> may be a <code>String</code> (in which
     * case <code>offset</code> and <code>length</code> describe the part
     * of the String to use), an <code>int</code>, a <code>Number</code>
     *
     * @param inobject An <code>Object</code> to create the <code>BigDecimal</code> from;
     * should not be null, NaN, +Infinity or -Infinity
     * @param offset If <code>inobject</code> is a <code>String</code>, the offset into
     * character array of the start of the number to be converted.
     * @param length If <code>inobject</code> is a <code>String</code>, the length of the number
     */
	 
    public function new(inobject : Dynamic = 0, offset : Int = 0, length : Int = -1)
    {
        if (Std.is(inobject, String))
        {
            createFromString(Std.string(inobject), offset, length);
        }
        else
        {
            if (Std.is(inobject, Int))
            {
                createFromInt(Std.int(inobject));
            }
            else
            {
                if (Std.is(inobject, Float))
                {
                    if (Math.isNaN(parseFloat(inobject)) || !Math.isFinite(parseFloat(inobject)))
                    {
                        throw new ArgumentError("Infinite or NaN");
                    }
                    createFromString(Std.string(parseFloat(inobject)), offset, length);
                }
                else
                {
                    if (inobject == null)
                    {
                        throw new ArgumentError("The inobject parameter cannot be null");
                    }
                    else
                    {
                        if (inobject != NULL)
                        {
                            //ActionScript 3 : allow internal code to bypass constructor
                            {
                                throw new ArgumentError("Unhandled parameter type: " + Type.getClassName(inobject));
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     * Populates this BigDecimal from the given string
     * @param str string to build BigDecimal from
     * @param offset offset to start parsing at
     * @param length length of the substring to parse, if any, otherwise -1
     * @throws ArgumentError if the given string, offset or length are invalid
     */
    private function createFromString(str : String, offset : Int = 0, length : Int = -1) : Void
    {
        if (length == -1)
        {
            length = str.length;
        }
        
        if (length <= 0 || length - offset > str.length)
        {
            throw new ArgumentError("Invalid offset/length: " + offset + "/" + length + " for string: " + str);
        }
        
        var scientific : Bool = false;  // true for XXXeYYY numbers  
        var dot : Int = -1;  // index of decimal point, if any  
        var c : Int;  // current character code  
        
        // check for sign
        ind = 1;  // assume positive  
        c = str.charCodeAt(offset);
        if (c == CODE_minus)
        {
            // negative number
            ind = -1;
            offset++;
        }
        else
        {
            if (c == CODE_plus)
            {
                offset++;
            }
        }
        
        // locate mantissa, dot and exponent indicator
        var nz : Int = offset;
        var zero : Bool = true;  // true if the last mantissa digit was zero 
		var i:Int = 0;
        for (_i in offset...length)
        {
			i  = _i;
            c = str.charCodeAt(i);
            if (c >= CODE_0 && c <= CODE_9)
            {
                if (zero)
                {
                    offset = i;
                }
                if (c != CODE_0)
                {
                    nz = i;  // index of last *non-zero* number in mantissa  
                    zero = false;
                }
                continue;
            }
            
            if (c == CODE_dot)
            {
                if (dot != -1)
                {
                    throw new ArgumentError("Not a number: " + str);
                }
                // save dot index and continue
                dot = i;
                continue;
            }
            
            if (c == CODE_e || c == CODE_E)
            {
                // process exponent in a different loop
                scientific = true;
                break;
            }
            
            throw new ArgumentError("Not a number: " + str);
        }
        
        var end : Int = Std.int(i - 1);  // index of final mantissa digit  
        
        // determine mantissa storage length
        var len : Int = Std.int(i - offset - ((dot >= offset) ? 1 : 0));
        if (len == 0)
        {
            throw new ArgumentError("Not a number: " + str);
        }
        
        // allocate and populate mantissa
        mant = new Array<Int>();
		i = 0;
		while(offset <= nz)
        {
            c = str.charCodeAt(offset);
            if (offset != dot)
            {
                mant[i++] = (c - CODE_0);
            }
			offset ++;
        }
        
        // zero?
        if (mant[0] == 0)
        {
            ind = 0;
        }
        
        // parse exponent
        var exponent : Float = 0;
        if (scientific)
        {
            offset = Std.int(end + 2);  // offset is the index of first exponent digit  
            
            var neg : Bool = false;
            c = str.charCodeAt(offset);
            if (c == CODE_minus)
            {
                // negative exponent
                neg = true;
                offset++;
            }
            else
            {
                if (c == CODE_plus)
                {
                    offset++;
                }
            }
            
            if (length - offset > 10)
            {
                throw new ArgumentError("Exponent too large: " + str);
            }
            
            for (i in offset...length)
            {
                c = str.charCodeAt(i);
                if (c >= CODE_0 && c <= CODE_9)
                {
                    exponent = (exponent * 10) + (c - CODE_0);
                    continue;
                }
                
                throw new ArgumentError("Not a number: " + str);
            }
            
            if (i == offset)
            {
                // no exponent digits
                {
                    throw new ArgumentError("Not a number: " + str);
                }
            }
            if (exponent > Number.MAX_SAFE_INTEGER)
            {
                throw new ArgumentError("Exponent too large: " + str);
            }
            
            if (neg)
            {
                exponent = -exponent;
            }
        }
        
        if (dot == -1)
        {
            // whole number? If so, dot is implicit
            {
                dot = end;
            }
        }
        
        // set exponent, adjusting for dot position if any
        exp = Std.int(exponent - (end - dot));
    }
    
    /**
     * Constructs a <code>BigDecimal</code> object directly from a
     * <code>int</code>.
     * <p>
     * Constructs a <code>BigDecimal</code> which is the exact decimal
     * representation of the 32-bit signed binary integer parameter.
     * The <code>BigDecimal</code> will contain only decimal digits,
     * prefixed with a leading minus sign (hyphen) if the parameter is
     * negative.
     * A leading zero will be present only if the parameter is zero.
     *
     * @param num The <code>int</code> to be converted.
     * @stable ICU 2.0
     */
    private function createFromInt(num : Int = 0) : Void
    {
        var mun : Int;
        var i : Int;
        
        // We fastpath commoners
        if (num <= 9)
        {
            if (num >= -9)
            {
                /*singledigit*/
                {
                    // very common single digit case
                    if (num == 0)
                    {
                        mant = ZERO.mant;
                        ind = iszero;
                    }
                    else
                    {
                        if (num == 1)
                        {
                            mant = ONE.mant;
                            ind = ispos;
                        }
                        else
                        {
                            if (num == -1)
                            {
                                mant = ONE.mant;
                                ind = isneg;
                            }
                            else
                            {
                                mant = new Array<Int>();
                                if (num > 0)
                                {
                                    mant[0] = num;
                                    ind = ispos;
                                }
                                else
                                {
                                    // num<-1
                                    mant[0] = -num;
                                    ind = isneg;
                                }
                            }
                        }
                    }
                    
                    return;
                }
            }
        }
        
        /* We work on negative numbers so we handle the most negative number */
        if (num > 0)
        {
            ind = ispos;
            num = -num;
        }
        else
        {
            ind = isneg;
        }
        
        // [it is quicker, here, to pre-calculate the length with
        // one loop, then allocate exactly the right length of byte array,
        // then re-fill it with another loop]
        mun = num;  // working copy  
        
        i = 9;
        while (true)
        {
            mun = Std.int(mun / 10);
            if (mun == 0)
            {
                break;
            }
            i--;
        }
        
        // i is the position of the leftmost digit placed
        mant = new Array<Int>();
        i = Std.int((10 - i) - 1);
                while (true)
        {
            mant[i] = -(Std.int(num % 10));
            num = Std.int(num / 10);
            if (num == 0)
            {
                break;
            }
            i--;
        }
    }
    
    /**
     * Constructs a <code>BigDecimal</code> object directly from a
     * <code>long</code>.
     * <p>
     * Constructs a <code>BigDecimal</code> which is the exact decimal
     * representation of the 64-bit signed binary integer parameter.
     * The <code>BigDecimal</code> will contain only decimal digits,
     * prefixed with a leading minus sign (hyphen) if the parameter is
     * negative.
     * A leading zero will be present only if the parameter is zero.
     *
     * @param num The <code>long</code> to be converted.
     * @stable ICU 2.0
     */
    //ActionScript 3 : This is to patch the fact that AS3 dont support Overriding
    //of Methods.  We need a way to construct the static constants without using
    //them in the 1st place with the normal int constructor.
    private static function createStatic(num : Int) : BigDecimal
    {
        var r : BigDecimal = new BigDecimal(NULL);
        
        // Not really worth fastpathing commoners in this constructor [also,
        // we use this to construct the static constants].
        // This is much faster than: this(String.valueOf(num).toCharArray())
        /* We work on negative num so we handle the most negative number */
        
        if (num > 0)
        {
            r.ind = ispos;
            num = -num;
        }
        else
        {
            if (num == 0)
            {
                r.ind = iszero;
            }
            else
            {
                r.ind = isneg;
            }
        }
        
        var mun : Int = num;
        var i : Int = 18;
                while (true)
        {
            mun = Std.int(mun / 10);
            if (mun == 0)
            {
                break;
            }
            i--;
        }
        
        // i is the position of the leftmost digit placed
        r.mant = new Array<Int>();
        i = Std.int((19 - i) - 1);
                while (true)
        {
            r.mant[i] = -num % 10;
            num = Std.int(num / 10);
            if (num == 0)
            {
                break;
            }
            i--;
        }
        
        return r;
    }
    
    /* ---------------------------------------------------------------- */
    /* Operator methods [methods which take a context parameter] */
    /* ---------------------------------------------------------------- */
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is the absolute value of
     * <code>this</code>. The result is rounded according to the passed context
     * <code>context</code>.
     *
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>abs(this)</code>
     */
    public function abs(context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        if (ind == isneg)
        {
            return negate(context);
        }
        return plus(context);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is <code>this + rhs</code>.
     * The result is rounded according to the passed context <code>context</code>.
     *
     * @param rhs
     *            value to be added to <code>this</code>.
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>this + rhs</code>.
     */
    public function add(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        var newlen : Int = 0;
        var tlen : Int = 0;
        var mult : Int = 0;
        var t : Array<Int> = null;
        var ia : Int = 0;
        var ib : Int = 0;
        var ea : Int = 0;
        var eb : Int = 0;
        var ca : Int = 0;
        var cb : Int = 0;
        
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        /* determine requested digits and form */
        if (context.lostDigits)
        {
            checkdigits(rhs, context.digits);
        }
        
        var lhs : BigDecimal = this;  // name for clarity and proxy  
        
        /* Quick exit for add floating 0 */
        // plus() will optimize to return same object if possible
        if (lhs.ind == iszero)
        {
            return rhs.plus(context);
        }
        if (rhs.ind == iszero)
        {
            return lhs.plus(context);
        }
        
        /* Prepare numbers (round, unless unlimited precision) */
        var reqdig : Int = context.digits;  // local copy (heavily used)  
        if (reqdig > 0)
        {
            if (lhs.mant.length > reqdig)
            {
                lhs = clone(lhs).roundContext(context);
            }
            if (rhs.mant.length > reqdig)
            {
                rhs = clone(rhs).roundContext(context);
            }
        }
        
        var res : BigDecimal = new BigDecimal();  // build result here  
        
        /* Now see how much we have to pad or truncate lhs or rhs in order
         to align the numbers. If one number is much larger than the
         other, then the smaller cannot affect the answer [but we may
         still need to pad with up to DIGITS trailing zeros]. */
        // Note sign may be 0 if digits (reqdig) is 0
        // usel and user will be the byte arrays passed to the adder; we'll
        // use them on all paths except quick exits
        var usel : Array<Int> = lhs.mant;
        var usellen : Int = lhs.mant.length;
        var user : Array<Int> = rhs.mant;
        var userlen : Int = rhs.mant.length;
        
        /*padder*/
        if (lhs.exp == rhs.exp)
        {
            /* no padding needed */
            // This is the most common, and fastest, path
            res.exp = lhs.exp;
        }
        else
        {
            if (lhs.exp > rhs.exp)
            {
                // need to pad lhs and/or truncate rhs
                newlen = Std.int((usellen + lhs.exp) - rhs.exp);
                /* If, after pad, lhs would be longer than rhs by digits+1 or
                 more (and digits>0) then rhs cannot affect answer, so we only
                 need to pad up to a length of DIGITS+1. */
                if (newlen >= ((userlen + reqdig) + 1))
                {
                    if (reqdig > 0)
                    {
                        // LHS is sufficient
                        res.mant = usel;
                        res.exp = lhs.exp;
                        res.ind = lhs.ind;
                        
                        if (usellen < reqdig)
                        {
                            // need 0 padding
                            res.mant = padBy(lhs.mant, reqdig - lhs.mant.length);
                            //                        res.mant = lhs.mant.slice();
                            //                        res.mant.length = reqdig;
                            res.exp = res.exp - reqdig - usellen;
                        }
                        
                        return res.finish(context);
                    }
                }
                
                // RHS may affect result
                res.exp = rhs.exp;  // expected final exponent  
                if (newlen > (reqdig + 1))
                {
                    if (reqdig > 0)
                    {
                        // LHS will be max; RHS truncated
                        tlen = Std.int((newlen - reqdig) - 1);  // truncation length  
                        userlen = Std.int(userlen - tlen);
                        res.exp = res.exp + tlen;
                        newlen = Std.int(reqdig + 1);
                    }
                }
                if (newlen > usellen)
                {
                    usellen = newlen;
                }
            }
            else
            {
                // need to pad rhs and/or truncate lhs
                newlen = Std.int((userlen + rhs.exp) - lhs.exp);
                if (newlen >= ((usellen + reqdig) + 1))
                {
                    if (reqdig > 0)
                    {
                        // RHS is sufficient
                        res.mant = user;
                        res.exp = rhs.exp;
                        res.ind = rhs.ind;
                        if (userlen < reqdig)
                        {
                            // need 0 padding
                            res.mant = padBy(rhs.mant, reqdig - rhs.mant.length);
                            //                        res.mant = rhs.mant.slice();
                            //                        res.mant.length = reqdig;
                            res.exp = res.exp - reqdig - userlen;
                        }
                        return res.finish(context);
                    }
                }
                // LHS may affect result
                res.exp = lhs.exp;  // expected final exponent  
                if (newlen > (reqdig + 1))
                {
                    if (reqdig > 0)
                    {
                        // RHS will be max; LHS truncated
                        tlen = Std.int((newlen - reqdig) - 1);  // truncation length  
                        usellen = Std.int(usellen - tlen);
                        res.exp = res.exp + tlen;
                        newlen = Std.int(reqdig + 1);
                    }
                }
                if (newlen > userlen)
                {
                    userlen = newlen;
                }
            }
        }
        /*padder*/
        
        /* OK, we have aligned mantissas. Now add or subtract. */
        // 1998.06.27 Sign may now be 0 [e.g., 0.000] .. treat as positive
        // 1999.05.27 Allow for 00 on lhs [is not larger than 2 on rhs]
        // 1999.07.10 Allow for 00 on rhs [is not larger than 2 on rhs]
        if (lhs.ind == iszero)
        {
            res.ind = ispos;
        }
        else
        {
            res.ind = lhs.ind;
        }
        if ((((lhs.ind == isneg)) ? 1 : 0) == (((rhs.ind == isneg)) ? 1 : 0))
        {
            // same sign, 0 non-negative
            mult = 1;
        }
        else
        {
            /*signdiff*/
            // different signs, so subtraction is needed
            mult = -1;  // will cause subtract  
            /* Before we can subtract we must determine which is the larger,
             as our add/subtract routine only handles non-negative results
             so we may need to swap the operands. */
            /*swaptest*/
            if (rhs.ind == iszero)
            {  // original A bigger  
                
            }
            else
            {
                if ((usellen < userlen) || (lhs.ind == iszero))
                {
                    // original B bigger
                    t = usel;
                    usel = user;
                    user = t;  // swap  
                    tlen = usellen;
                    usellen = userlen;
                    userlen = tlen;  // ..  
                    res.ind = -res.ind;
                }
                else
                {
                    if (usellen > userlen)
                    {  // original A bigger  
                        
                    }
                    else
                    {
                        /* logical lengths the same */  // need compare  
                        /* may still need to swap: compare the strings */
                        ia = 0;
                        ib = 0;
                        ea = Std.int(usel.length - 1);
                        eb = Std.int(user.length - 1);
                                                while (true)
                        {
                            /*compare*/
                            {
                                if (ia <= ea)
                                {
                                    ca = usel[ia];
                                }
                                else
                                {
                                    if (ib > eb)
                                    {
                                        // [we must do the subtract, in case of 0.000 results]
                                        break  /*compare*/  ;
                                    }
                                    ca = 0;
                                }
                                
                                if (ib <= eb)
                                {
                                    cb = user[ib];
                                }
                                else
                                {
                                    cb = 0;
                                }
                                if (ca != cb)
                                {
                                    if (ca < cb)
                                    {
                                        /* swap needed */
                                        t = usel;
                                        usel = user;
                                        user = t;  // swap  
                                        tlen = usellen;
                                        usellen = userlen;
                                        userlen = tlen;  // ..  
                                        res.ind = -res.ind;
                                    }
                                    break  /*compare*/  ;
                                }
                                /* mantissas the same, so far */
                                ia++;
                                ib++;
                            }
                        }
                    }
                }
            }
        }
        /*swaptest*/
        /*signdiff*/
        
        /* here, A is > B if subtracting */
        // add [A+B*1] or subtract [A+(B*-1)]
        res.mant = byteaddsub(usel, usellen, user, userlen, mult, false);
        // [reuse possible only after chop; accounting makes not worthwhile]
        
        // Finish() rounds before stripping leading 0's, then sets form, etc.
        return res.finish(context);
    }
    
    /**
     * Compares this <code>BigDecimal</code> with <code>rhs</code>. Returns one of the
     * three values <code>1</code>, <code>0</code>, or <code>-1</code>. The method behaves as
     * if <code>this.subtract(rhs)</code> is computed. If this difference is > 0 then
     * 1 is returned, if the difference is < 0 then -1 is returned, and if the
     * difference is 0 then 0 is returned. This means, that if two decimal
     * instances are compared which are equal in value but differ in scale, then
     * these two instances are considered as equal.
     *
     * @param rhs
     *            value to be compared with <code>this</code>.
     * @return <code>1</code> if <code>this > rhs</code>, <code>-1</code> if <code>this < rhs</code>,
     *         <code>0</code> if <code>this == rhs</code>.
     */
    public function compareTo(rhs : BigDecimal, context : MathContext = null) : Int
    {
        var thislength : Int = 0;
        var i : Int = 0;
        var newrhs : BigDecimal;
        
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        // rhs=null will raise NullPointerException, as per Comparable interface
        if (context.lostDigits)
        {
            checkdigits(rhs, context.digits);
        }
        
        // [add will recheck in slowpath cases .. but would report -rhs]
        if (this.ind == rhs.ind && this.exp == rhs.exp)
        {
            /* sign & exponent the same [very common] */
            thislength = mant.length;
            if (thislength < rhs.mant.length)
            {
                return -ind;
            }
            if (thislength > rhs.mant.length)
            {
                return ind;
            }
            /* lengths are the same; we can do a straight mantissa compare
             unless maybe rounding [rounding is very unusual] */
            if (thislength <= context.digits || context.digits == 0)
            {
                var __DOLLAR__6 : Int = thislength;
                i = 0;
                                while (__DOLLAR__6 > 0)
                {
                    if (mant[i] < rhs.mant[i])
                    {
                        return -ind;
                    }
                    if (mant[i] > rhs.mant[i])
                    {
                        return ind;
                    }
                    __DOLLAR__6--;
                    i++;
                }
                return 0;
            }
        }
        else
        {
            /* More fastpaths possible */
            if (this.ind < rhs.ind)
            {
                return -1;
            }
            if (this.ind > rhs.ind)
            {
                return 1;
            }
        }
        /* carry out a subtract to make the comparison */
        newrhs = clone(rhs);  // safe copy  
        newrhs.ind = -newrhs.ind;  // prepare to subtract  
        return add(newrhs, context).ind;
    }
    
    /**
     * Returns a plain <code>BigDecimal</code> whose value is
     * <code>this/rhs</code>, using fixed point arithmetic.
     * <p>
     * The same as {@link #divide(BigDecimal, int)},
     * where the <code>BigDecimal</code> is <code>rhs</code>,
     * and the rounding mode is {@link MathContext#ROUND_HALF_UP}.
     *
     * The length of the decimal part (the scale) of the result will be
     * the same as the scale of the current object, if the latter were
     * formatted without exponential notation.
     *
     * @param rhs The <code>BigDecimal</code> for the right hand side of
     * the division.
     * @return A plain <code>BigDecimal</code> whose value is
     * <code>this/rhs</code>, using fixed point arithmetic.
     * @throws ArithmeticError if <code>rhs</code> is zero.
     * @stable ICU 2.0
     */
    
    /*      ActionScript 3 : Flex override is with default parameters

     public function divide(rhs:BigDecimal):BigDecimal {
     return this.dodivide('D',rhs,MathContext.PLAIN,-1);
     }
     */
    /**
     * Returns a plain <code>BigDecimal</code> whose value is
     * <code>this/rhs</code>, using fixed point arithmetic and a
     * rounding mode.
     * <p>
     * The same as {@link #divide(BigDecimal, int, int)},
     * where the <code>BigDecimal</code> is <code>rhs</code>,
     * and the second parameter is <code>this.scale()</code>, and
     * the third is <code>round</code>.
     * <p>
     * The length of the decimal part (the scale) of the result will
     * therefore be the same as the scale of the current object, if the
     * latter were formatted without exponential notation.
     * <p>
     * @param rhs The <code>BigDecimal</code> for the right hand side of
     * the division.
     * @param round The <code>int</code> rounding mode to be used for
     * the division (see the {@link MathContext} class).
     * @return A plain <code>BigDecimal</code> whose value is
     * <code>this/rhs</code>, using fixed point arithmetic
     * and the specified rounding mode.
     * @throws Error if <code>round</code> is not a
     * valid rounding mode.
     * @throws ArithmeticError if <code>rhs</code> is zero.
     * @throws ArithmeticError if <code>round</code> is
     * {@link MathContext#ROUND_UNNECESSARY} and
     * <code>this.scale()</code> is insufficient to
     * represent the result exactly.
     * @stable ICU 2.0
     */
    public function divideRound(rhs : BigDecimal, round : Int) : BigDecimal
    {
        var context : MathContext;
        context = new MathContext(0, false, round);  // [checks round, too]  
        return dodivide("D", rhs, context, -1);
    }
    
    /**
     * Returns a plain <code>BigDecimal</code> whose value is
     * <code>this/rhs</code>, using fixed point arithmetic and a
     * given scale and rounding mode.
     * <p>
     * The same as {@link #divide(BigDecimal, MathContext)},
     * where the <code>BigDecimal</code> is <code>rhs</code>,
     * <code>new MathContext(0, MathContext.PLAIN, false, round)</code>,
     * except that the length of the decimal part (the scale) to be used
     * for the result is explicit rather than being taken from
     * <code>this</code>.
     * <p>
     * The length of the decimal part (the scale) of the result will be
     * the same as the scale of the current object, if the latter were
     * formatted without exponential notation.
     * <p>
     * @param rhs The <code>BigDecimal</code> for the right hand side of
     * the division.
     * @param scale The <code>int</code> scale to be used for the result.
     * @param round The <code>int</code> rounding mode to be used for
     * the division (see the {@link MathContext} class).
     * @return A plain <code>BigDecimal</code> whose value is
     * <code>this/rhs</code>, using fixed point arithmetic
     * and the specified rounding mode.
     * @throws Error if <code>round</code> is not a
     * valid rounding mode.
     * @throws ArithmeticError if <code>rhs</code> is zero.
     * @throws ArithmeticError if <code>scale</code> is negative.
     * @throws ArithmeticError if <code>round</code>
     * is {@link MathContext#ROUND_UNNECESSARY} and <code>scale</code>
     * is insufficient to represent the result exactly.
     * @stable ICU 2.0
     */
    public function divideScaleRound(rhs : BigDecimal, scale : Int, round : Int) : BigDecimal
    {
        var context : MathContext;
        if (scale < 0)
        {
            throw new ArithmeticError("Negative scale:" + " " + scale);
        }
        context = new MathContext(0, false, round);  // [checks round]  
        return dodivide("D", rhs, context, scale);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is <code>this / rhs</code>.
     * The result is rounded according to the passed context <code>context</code>. If the
     * passed math context specifies precision <code>0</code>, then this call is
     * equivalent to <code>this.divide(rhs)</code>.
     *
     * @param rhs
     *            value by which <code>this</code> is divided.
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>this / rhs</code>.
     */
    public function divide(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        return dodivide("D", rhs, context, -1);
    }
    
    /**
     * Returns a plain <code>BigDecimal</code> whose value is the integer
     * part of <code>this/rhs</code>.
     * <p>
     * The same as {@link #divideInteger(BigDecimal, MathContext)},
     * where the <code>BigDecimal</code> is <code>rhs</code>,
     * and the context is <code>new MathContext(0, MathContext.PLAIN)</code>.
     *
     * @param rhs The <code>BigDecimal</code> for the right hand side of
     * the integer division.
     * @return A <code>BigDecimal</code> whose value is the integer
     * part of <code>this/rhs</code>.
     * @throws ArithmeticError if <code>rhs</code> is zero.
     * @stable ICU 2.0
     */
    
    /*      ActionScript 3 : Flex override is with default parameters

     public function divideInteger(rhs:BigDecimal):BigDecimal {
     // scale 0 to drop .000 when plain
     return this.dodivide('I',rhs,MathContext.PLAIN,0);
     }
     */
    /**
     * Returns a <code>BigDecimal</code> whose value is the integer
     * part of <code>this/rhs</code>.
     * <p>
     * Implements the integer division operator
     * (as defined in the decimal documentation, see {@link BigDecimal
     * class header}),
     * and returns the result as a <code>BigDecimal</code> object.
     *
     * @param rhs The <code>BigDecimal</code> for the right hand side of
     * the integer division.
     * @param context The <code>MathContext</code> arithmetic settings.
     * @return A <code>BigDecimal</code> whose value is the integer
     * part of <code>this/rhs</code>.
     * @throws ArithmeticError if <code>rhs</code> is zero.
     * @throws ArithmeticError if the result will not fit in the
     * number of digits specified for the context.
     * @stable ICU 2.0
     */
    public function divideInteger(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        // scale 0 to drop .000 when plain
        return dodivide("I", rhs, context, 0);
    }
    
    /**
     * Returns the maximum of this <code>BigDecimal</code> and <code>rhs</code>.
     *
     * @param rhs
     *            value to be used to compute the maximum with this.
     * @return <code>max(this, rhs</code>.
     */
    public function max(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        if (compareTo(rhs, context) >= 0)
        {
            return this.plus(context);
        }
        else
        {
            return rhs.plus(context);
        }
    }
    
    /**
     * Returns the minimum of this <code>BigDecimal</code> and <code>rhs</code>.
     *
     * @param rhs
     *            value to be used to compute the minimum with this.
     * @return <code>min(this, rhs</code>.
     */
    public function min(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        if (compareTo(rhs, context) <= 0)
        {
            return this.plus(context);
        }
        else
        {
            return rhs.plus(context);
        }
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is {@code this *
     * rhs}. The result is rounded according to the passed context
     * <code>context</code>.
     *
     * @param rhs
     *            value to be multiplied with <code>this</code>.
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>this * rhs</code>.
     */
    public function multiply(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        var lhs : BigDecimal;
        var reqdig : Int;
        var multer : Array<Int> = null;
        var multand : Array<Int> = null;
        var multandlen : Int;
        var acclen : Int = 0;
        var res : BigDecimal;
        var acc : Array<Int>;
        var n : Int;
        var mult : Int = 0;
        
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        if (context.lostDigits)
        {
            checkdigits(rhs, context.digits);
        }
        lhs = this;  // name for clarity and proxy  
        
        /* Prepare numbers (truncate, unless unlimited precision) */
        reqdig = context.digits;  // local copy  
        
        if (reqdig > 0)
        {
            if (lhs.mant.length > reqdig)
            {
                lhs = clone(lhs).roundContext(context);
            }
            if (rhs.mant.length > reqdig)
            {
                rhs = clone(rhs).roundContext(context);
            }
        }
        
        // For best speed, as in DMSRCN, we use the shorter number as the
        // multiplier and the longer as the multiplicand.
        // 1999.12.22: We used to special case when the result would fit in
        // a long, but with Java 1.3 this gave no advantage.
        if (lhs.mant.length < rhs.mant.length)
        {
            multer = lhs.mant;
            multand = rhs.mant;
        }
        else
        {
            multer = rhs.mant;
            multand = lhs.mant;
        }
        
        /* Calculate how long result byte array will be */
        multandlen = Std.int((multer.length + multand.length) - 1);  // effective length  
        // optimize for 75% of the cases where a carry is expected...
        if ((multer[0] * multand[0]) > 9)
        {
            acclen = Std.int(multandlen + 1);
        }
        else
        {
            acclen = multandlen;
        }
        
        /* Now the main long multiplication loop */
        res = new BigDecimal();  // where we'll build result  
        acc = new Array<Int>();  // accumulator, all zeros  
        // 1998.07.01: calculate from left to right so that accumulator goes
        // to likely final length on first addition; this avoids a one-digit
        // extension (and object allocation) each time around the loop.
        // Initial number therefore has virtual zeros added to right.
        var __DOLLAR__7 : Int = multer.length;
        n = 0;
        while (__DOLLAR__7 > 0)
        {
            mult = multer[n];
            if (mult != 0)
            {
                // [optimization]
                // accumulate [accumulator is reusable array]
                acc = byteaddsub(acc, acc.length, multand, multandlen, mult, true);
            }
            // divide multiplicand by 10 for next digit to right
            multandlen--;
            __DOLLAR__7--;
            n++;
        }
        
        res.ind = (lhs.ind * rhs.ind);  // final sign  
        res.exp = (lhs.exp + rhs.exp);  // final exponent  
        res.mant = acc;
        return res.finish(context);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is the <code>-this</code>. The
     * result is rounded according to the passed context <code>context</code>.
     *
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>-this</code>
     */
    public function negate(context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        var res : BigDecimal;
        // Originally called minus(), changed to matched Java precedents
        // This simply clones, flips the sign, and possibly rounds
        if (context.lostDigits)
        {
            checkdigits(try cast(null, BigDecimal) catch(e:Dynamic) null, context.digits);
        }
        res = clone(this);  // safe copy  
        res.ind = -res.ind;
        
        return res.finish(context);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is <code>+this</code>. The result
     * is rounded according to the passed context <code>context</code>.
     *
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>this</code>, rounded
     */
    public function plus(context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        // This clones and forces the result to the new settings
        // May return same object
        if (context.lostDigits)
        {
            checkdigits(try cast(null, BigDecimal) catch(e:Dynamic) null, context.digits);
        }
        // Optimization: returns same object for some common cases
        if (mant.length <= context.digits)
        {
            return this;
        }
        if (context.digits == 0)
        {
            return this;
        }
        return clone(this).finish(context);
    }
    
    // The name for this method is inherited from the precedent set by the
    // BigInteger and Math classes.
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is <code>this ^ n</code>. The
     * scale of the result is <code>n</code> times the scales of <code>this</code>.
     * <p>
     * <code>x.pow(0)</code> returns <code>1</code>, even if <code>x == 0</code>.
     * <p>
     * Implementation Note: The implementation is based on the ANSI standard
     * X3.274-1996 algorithm.
     *
     * @param n
     *            exponent to which <code>this</code> is raised.
     * @return <code>this ^ n</code>.
     * @throws ArithmeticError
     *             if <code>n < 0</code> or <code>n > 999999999</code>.
     */
    public function pow(n : Int, context : MathContext = null) : BigDecimal
    {
        if (n == 0)
        {
            return ONE;
        }
        
        if (n < 0 || n > 999999999)
        {
            throw new ArithmeticError("Invalid Operation");
        }
        
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        if (context.lostDigits)
        {
            checkdigits(null, context.digits);
        }
        
        var lhs : BigDecimal = this;  // clarified name  
        var workdigits : Int = 0;
        var reqdig : Int = context.digits;  // local copy (heavily used)  
        if (reqdig == 0)
        {
            workdigits = 0;
        }
        else
        {
            /* Round the lhs to DIGITS if need be */
            if (lhs.mant.length > reqdig)
            {
                lhs = clone(lhs).roundContext(context);
            }
            
            /* L for precision calculation [see ANSI X3.274-1996] */
            var L : Int = Std.string(n).length;  // length without decimal zeros/exp  
            
            /* non-0 digits */
            if (L > reqdig)
            {
                throw cast(("Too many digits: " + n), Error);
            }
            
            workdigits = Std.int((reqdig + L) + 1);
        }
        
        /* Create a copy of context for working settings */
        // Note: no need to check for lostDigits again.
        // 1999.07.17 Note: this construction must follow RHS check
        var workset : MathContext = new MathContext(workdigits, false, context.roundingMode);
        
        var seenbit : Bool = false;  // set once we've seen a 1-bit  
        var res : BigDecimal = ONE;  // accumulator  
        var i : Int = 1;
        while (true)
        {
            // for each bit [top bit ignored]
            n = Std.int(n + n);  // shift left 1 bit  
            if (n < 0)
            {
                // top bit is set
                seenbit = true;  // OK, we're off  
                res = res.multiply(lhs, workset);
            }
            if (i == 31)
            {
                break;
            }
            if (!seenbit)
            {
                {i++;continue;
                }
            }
            res = res.multiply(res, workset);
            i++;
        }
        // 32 bits
        
        return res.finish(context);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is <code>this % rhs</code>.
     * <p>
     * The remainder is defined as {@code this -
     * this.divideToIntegralValue(rhs) * rhs}.
     *
     * @param rhs
     *            value by which <code>this</code> is divided.
     * @return <code>this % rhs</code>.
     */
    public function remainder(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        return dodivide("R", rhs, context, -1);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> whose value is <code>this - rhs</code>.
     * The result is rounded according to the passed context <code>context</code>.
     *
     * @param rhs
     *            value to be subtracted from <code>this</code>.
     * @param context
     *            rounding mode and precision for the result of this operation.
     * @return <code>this - rhs</code>.
     */
    public function subtract(rhs : BigDecimal, context : MathContext = null) : BigDecimal
    {
        var newrhs : BigDecimal;
        
        if (context == null)
        {
            context = MathContext.PLAIN;
        }
        
        if (context.lostDigits)
        {
            checkdigits(rhs, context.digits);
        }
        // [add will recheck .. but would report -rhs]
        /* carry out the subtraction */
        // we could fastpath -0, but it is too rare.
        newrhs = clone(rhs);  // safe copy  
        newrhs.ind = -newrhs.ind;  // prepare to subtract  
        
        return add(newrhs, context);
    }
    
    /* ---------------------------------------------------------------- */
    /* Other methods */
    /* ---------------------------------------------------------------- */
    
    /**
     * Converts this <code>BigDecimal</code> to a <code>double</code>.
     * If the <code>BigDecimal</code> is out of the possible range for a
     * <code>double</code> (64-bit signed floating point) result then an
     * <code>ArithmeticException</code> is thrown.
     * <p>
     * The double produced is identical to result of expressing the
     * <code>BigDecimal</code> as a <code>String</code> and then
     * converting it using the <code>Double(String)</code> constructor;
     * this can result in values of <code>Double.NEGATIVE_INFINITY</code>
     * or <code>Double.POSITIVE_INFINITY</code>.
     *
     * @return A <code>double</code> corresponding to <code>this</code>.
     * @stable ICU 2.0
     */
    
    public function numberValue() : Float
    {
        // We go via a String [as does BigDecimal in JDK 1.2]
        // Next line could possibly raise NumberFormatException
        return parseFloat(toString());
    }
    
    /**
     * Returns <code>true</code> if <code>obj</code> is a <code>BigDecimal</code> instance and if
     * this instance is equal to this big decimal. Two big decimals are equal if
     * their unscaled value and their scale is equal. For example, 1.0
     * (10*10^(-1)) is not equal to 1.00 (100*10^(-2)). Similarly, zero
     * instances are not equal if their scale differs.
     *
     * @param obj
     *            object to be compared with <code>this</code>.
     * @return true if <code>obj</code> is a <code>BigDecimal</code> and <code>this == obj</code>.
     */
    public function equals(obj : Dynamic) : Bool
    {
        // We are equal iff toString of both are exactly the same
        if (obj == null)
        {
            return false;
        }
        
        if (!(Std.is(obj, BigDecimal)))
        {
            return false;
        }
        
        var rhs : BigDecimal = try cast(obj, BigDecimal) catch(e:Dynamic) null;  // cast; we know it will work  
        if (this.ind != rhs.ind)
        {
            return false;
        }
        
        if (this.mant.length == rhs.mant.length && this.exp == rhs.exp)
        {
            // mantissas say all
            // here with equal-length byte arrays to compare
            var len : Int = mant.length;
            for (i in 0...len)
            {
                if (this.mant[i] != rhs.mant[i])
                {
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    
    /**
     * Converts this <code>BigDecimal</code> to an <code>int</code>.
     * If the <code>BigDecimal</code> has a non-zero decimal part it is
     * discarded. If the <code>BigDecimal</code> is out of the possible
     * range for an <code>int</code> (32-bit signed integer) result then
     * only the low-order 32 bits are used. (That is, the number may be
     * <i>decapitated</i>.) To avoid unexpected errors when these
     * conditions occur, use the {@link #intValueExact} method.
     *
     * @return An <code>int</code> converted from <code>this</code>,
     * truncated and decapitated if necessary.
     * @stable ICU 2.0
     */
    /* ActionScript : WONT PORT
     public int intValue(){
     return toBigInteger().intValue();
     }
     */
    
    /**
     * Returns this <code>BigDecimal</code> as a int value if it has no fractional
     * part and if its value fits to the int range ([-2^{31}..2^{31}-1]). If
     * these conditions are not met, an <code>ArithmeticException</code> is thrown.
     *
     * @return this <code>BigDecimal</code> as a int value.
     * @throws Error
     *             if rounding is necessary or the number doesn't fit in a int.
     */
    public function intValueExact() : Int
    {
        var lodigit : Int;
        var useexp : Int = 0;
        var result : Int;
        var i : Int;
        var topdig : Int = 0;
        // This does not use longValueExact() as the latter can be much
        // slower.
        // intcheck (from pow) relies on this to check decimal part
        if (ind == iszero)
        {
            return 0;
        }
        /* test and drop any trailing decimal part */
        
        lodigit = Std.int(mant.length - 1);
        if (exp < 0)
        {
            lodigit = Std.int(lodigit + exp);  // reduces by -(-exp)  
            /* all decimal places must be 0 */
            
            if (!allzero(mant, lodigit + 1))
            {
                throw new Error("Decimal part non-zero:" + " " + toString());
            }
            if (lodigit < 0)
            {
                return 0;
            }
            useexp = 0;
        }
        else
        {
            /* >=0 */
            
            if ((exp + lodigit) > 9)
            {
                // early exit
                throw new Error("Conversion overflow:" + " " + toString());
            }
            useexp = exp;
        }
        /* convert the mantissa to binary, inline for speed */
        
        result = 0;
        var __DOLLAR__16 : Int = Std.int(lodigit + useexp);
        i = 0;
                while (i <= __DOLLAR__16)
        {
            result = Std.int(result * 10);
            if (i <= lodigit)
            {
                result = Std.int(result + mant[i]);
            }
            i++;
        }
        
        /* Now, if the risky length, check for overflow */
        
        if ((lodigit + useexp) == 9)
        {
            // note we cannot just test for -ve result, as overflow can move a
            // zero into the top bit [consider 5555555555]
            topdig = Std.int(result / 1000000000);  // get top digit, preserving sign  
            if (topdig != mant[0])
            {
                // digit must match and be positive
                // except in the special case ...
				
                if (result == Number.MIN_SAFE_INTEGER)
                {
                    // looks like the special
                    if (ind == isneg)
                    {
                        // really was negative
                        if (mant[0] == 2)
                        {
                            return result;
                        }
                    }
                }
                
                throw new Error("Conversion overflow:" + " " + toString());
            }
        }
        
        /* Looks good */
        
        if (ind == ispos)
        {
            return result;
        }
        
        return -result;
    }
    
    /**
     * Returns a new <code>BigDecimal</code> instance where the decimal point has
     * been moved <code>n</code> places to the left. If <code>n < 0</code> then the
     * decimal point is moved <code>-n</code> places to the right.
     * <p>
     * The result is obtained by changing its scale. If the scale of the result
     * becomes negative, then its precision is increased such that the scale is
     * zero.
     * <p>
     * Note, that <code>movePointLeft(0)</code> returns a result which is
     * mathematically equivalent, but which has <code>scale >= 0</code>.
     *
     * @param n
     *            number of placed the decimal point has to be moved.
     * @return <code>this * 10^(-n</code>).
     */
    public function movePointLeft(n : Int) : BigDecimal
    {
        return movePoint(-n);
    }
    
    /**
     * Returns a new <code>BigDecimal</code> instance where the decimal point has
     * been moved <code>n</code> places to the right. If <code>n < 0</code> then the
     * decimal point is moved <code>-n</code> places to the left.
     * <p>
     * The result is obtained by changing its scale. If the scale of the result
     * becomes negative, then its precision is increased such that the scale is
     * zero.
     * <p>
     * Note, that <code>movePointRight(0)</code> returns a result which is
     * mathematically equivalent, but which has scale >= 0.
     *
     * @param n
     *            number of placed the decimal point has to be moved.
     * @return <code>this * 10^n</code>.
     */
    public function movePointRight(n : Int) : BigDecimal
    {
        return movePoint(n);
    }
    
    private function movePoint(n : Int) : BigDecimal
    {
        var res : BigDecimal = clone(this);
        res.exp = toIntExponent(exp + n);
        res = res.finish(MathContext.PLAIN);
        return (res.exp < 0) ? res : res.setScale(0, MathContext.ROUND_UNNECESSARY);
    }
    
    /**
     * Returns the scale of this <code>BigDecimal</code>. The scale is the number of
     * digits behind the decimal point. The value of this <code>BigDecimal</code> is
     * the unsignedValue * 10^(-scale). If the scale is negative, then this
     * <code>BigDecimal</code> represents a big integer.
     *
     * @return the scale of this <code>BigDecimal</code>.
     */
    public function scale() : Int
    {
        return -exp;
    }
    
    /**
     * Returns a new <code>BigDecimal</code> instance with the specified scale.
     * <p>
     * If the new scale is greater than the old scale, then additional zeros are
     * added to the unscaled value. In this case no rounding is necessary.
     * <p>
     * If the new scale is smaller than the old scale, then trailing digits are
     * removed. If these trailing digits are not zero, then the remaining
     * unscaled value has to be rounded. For this rounding operation the
     * specified rounding mode is used.
     *
     * @param scale
     *            scale of the result returned.
     * @param round
     *            rounding mode to be used to round the result.
     * @return a new <code>BigDecimal</code> instance with the specified scale.
     */
    public function setScale(scale : Int, round : Int = -1) : BigDecimal
    {
        //ActionScript 3
        //Correct the default parameter patch because of
        //Compiler bug for the compile time constants
        if (round == -1)
        {
            round = MathContext.ROUND_UNNECESSARY;
        }
        
        // at present this naughtily only checks the round value if it is
        // needed (used), for speed
        var ourscale : Int = this.scale();
        if (ourscale == scale)
        {
            // already correct scale
            return this;
        }
        
        var res : BigDecimal = clone(this);  // need copy  
        if (ourscale <= scale)
        {
            // simply zero-padding/changing form
            if (ind != iszero)
            {
                //no need to pad; adding zeroes just inflates the mantissa
                {
                    // if ourscale is 0 we may have lots of 0s to add
                    var padding : Int = 0;
                    if (ourscale == 0)
                    {
                        padding = Std.int(res.exp + scale);
                    }
                    else
                    {
                        padding = Std.int(scale - ourscale);
                    }
                    res.mant = padBy(res.mant, padding);
                    res.exp = -scale;
                }
            }
        }
        else
        {
            /* ourscale>scale: shortening, probably */
            if (scale < 0)
            {
                throw new Error("Negative scale:" + " " + scale);
            }
            // [round() will raise exception if invalid round]
			//trace('rounding method 2' ,res.mant.length, ourscale, scale, res.mant.length - ourscale - scale);
            var newlen : Int = Std.int(res.mant.length - (ourscale - scale));  // [<=0 is OK]  
			//trace('>>>>', newlen, res.mant.length, ourscale, scale);
			//trace(res.mant);
            res = res.round(newlen, round);  // round to required length  
			//trace(res.mant);
             //This could have shifted left if round (say) 0.9->1[.0]
            // Repair if so by adding a zero and reducing exponent
            if (res.exp != (-scale))
            {
                res.mant = padBy(res.mant, 1);
                //                res.mant = res.mant.slice(); // cannot re-use, make a copy
                //                res.mant.length += 1; // and extend
                res.exp = res.exp - 1;
            }
        }
        return res;
    }
    
    /**
     * Returns the sign of this <code>BigDecimal</code>.
     *
     * @return <code>-1</code> if <code>this < 0</code>,
     *         <code>0</code> if <code>this == 0</code>,
     *         <code>1</code> if <code>this > 0</code>.
     */
    public function signum() : Int
    {
        return ind;
    }
    
    /**
     * Returns a canonical string representation of this <code>BigDecimal</code>. If
     * necessary, scientific notation is used. This representation always prints
     * all significant digits of this value.
     * <p>
     * If the scale is negative or if <code>scale - precision >= 6</code> then
     * scientific notation is used.
     *
     * @return a string representation of <code>this</code> in scientific notation if
     *         necessary.
     */
    public function toCanonicalString() : String
    {
		var buf : Array<String> = [];
		for (digit in mant) {
			buf.push(Std.string(digit));
		}
		
        if (ind < 0)
        {
            EcmaHX_Compat.arraySplice(buf, 0, 0, ["-"]);
        }
        if (scale() == 0)
        {
            return buf.join("");
        }
        
        var begin : Int = ((ind < 0)) ? 2 : 1;
        var end : Int = buf.length;
        var exponent : Int = Std.int(-scale() + end - begin);
        
        if (scale() > 0 && exponent >= -6)
        {
            if (exponent >= 0)
            {
                EcmaHX_Compat.arraySplice(buf, end - scale(), 0, ["."]);
            }
            else
            {
                EcmaHX_Compat.arraySplice(buf, begin - 1, 0, ["0", "."]);
                for (i in 0...-exponent - 1)
                {
                    EcmaHX_Compat.arraySplice(buf, begin + 1, 0, ["0"]);
                }
            }
        }
        else
        {
            if (end - begin >= 1)
            {
                EcmaHX_Compat.arraySplice(buf, begin, 0, ["."]);
            }
            buf[buf.length] = "E";
            if (exponent > 0)
            {
                buf[buf.length] = "+";
            }
            buf[buf.length] = Std.string(exponent);
        }
        return buf.join("");
    }
    
    /**
     * Returns a string representation of this <code>BigDecimal</code>. This
     * representation always prints all significant digits of this value.
     * <p>
     * If the scale is negative or if <code>scale - precision >= 6</code> then
     * engineering notation is used. Engineering notation is similar to the
     * scientific notation except that the exponent is made to be a multiple of
     * 3 such that the integer part is >= 1 and < 1000.
     *
     * @return a string representation of <code>this</code> in engineering notation
     *         if necessary.
     */
    public function toEngineeringString() : String
    {
        var buf : Array<String> = [];
		for (digit in mant) {
			buf.push(Std.string(digit));
		}
		
        if (ind < 0)
        {
            EcmaHX_Compat.arraySplice(buf, 0, 0, ["-"]);
        }
        if (exp == 0)
        {
            return buf.join("");
        }
        
        var begin : Int = ((ind < 0)) ? 2 : 1;
        var end : Int = buf.length;
        var exponent : Int = Std.int(exp + end - begin);
        
        if (-exp > 0 && exponent >= -6)
        {
            if (exponent >= 0)
            {
                EcmaHX_Compat.arraySplice(buf, end - scale(), 0, ["."]);
            }
            else
            {
                EcmaHX_Compat.arraySplice(buf, begin - 1, 0, ["0", "."]);  //$NON-NLS-1$  
                for (i in 0...-exponent - 1)
                {
                    EcmaHX_Compat.arraySplice(buf, begin + 1, 0, ["0"]);
                }
            }
        }
        else
        {
            var delta : Int = Std.int(end - begin);
            var rem : Int = Std.int(exponent % 3);
            
            if (rem != 0)
            {
                // adjust exponent so it is a multiple of three
                if (ind == 0)
                {
                    // zero value
                    rem = ((rem < 0)) ? -rem : 3 - rem;
                    exponent += rem;
                }
                else
                {
                    // nonzero value
                    rem = ((rem < 0)) ? rem + 3 : rem;
                    exponent -= rem;
                    begin += rem;
                }
                if (delta < 3)
                {
                    var i:Int = rem - delta;
                    while (i > 0)
                    {
                        EcmaHX_Compat.arraySplice(buf, end++, 0, ["0"]);
                        i--;
                    }
                }
            }
            if (end - begin >= 1)
            {
                EcmaHX_Compat.arraySplice(buf, begin, 0, ["."]);
            }
            if (exponent != 0)
            {
                buf[buf.length] = "E";
                if (exponent > 0)
                {
                    buf[buf.length] = "+";
                }
                buf[buf.length] = Std.string(exponent);
            }
        }
        return buf.join("");
    }
    
    /**
     * @inheritDoc #toString
     * This method is an alias for {@link #toString}
     */
    public function toPlainString() : String
    {
        return toString();
    }
    
    /**
     * Returns a string representation of this <code>BigDecimal</code>. No scientific
     * notation is used. This methods adds zeros where necessary.
     * <p>
     * If this string representation is used to create a new instance, this
     * instance is generally not identical to <code>this</code> as the precision
     * changes.
     * <p>
     * <code>x.equals(new BigDecimal(x.toPlainString())</code> usually returns
     * <code>false</code>.
     * <p>
     * <code>x.compareTo(new BigDecimal(x.toPlainString())</code> returns <code>0</code>.
     *
     * @return a string representation of <code>this</code> without exponent part.
     */
    public function toString() : String
    {
        if (string != null)
        {
            return string;
        }
		var pos : Int;
		var pad : Int;
        
        var len : Int = mant.length;
        var buf : Array<String> = new Array<String>();
        if (ind < 0)
        {
            buf[buf.length] = "-";
        }
        var dot : Int = -1;
        if (exp < 0)
        {
            if (-exp >= len)
            {
                buf[buf.length] = "0.";
                pos = buf.length;
                pad = Std.int(-exp - len);
                //buf.length += pad;
                while (pad-- > 0)
                {
                    buf[pos] = "0";
                    pos++;
                }
            }
            else
            {
                dot = Std.int(len + exp);
            }
        }
        for (i in 0...len)
        {
            if (i == dot)
            {
                buf[buf.length] = ".";
            }
            buf[buf.length] = Std.string(mant[i]);
        }
        if (exp > 0 && ind != iszero)
        {
            pos = buf.length;
            pad = exp;
            //buf.length += pad;
            while (pad-- > 0)
            {
                buf[pos] = "0";
                pos++;
            }
        }
        string = buf.join("");
        return string;
    }
    
    /**
     * Returns the number as a <code>BigInteger</code> after removing the
     * scale.
     * That is, the number is expressed as a plain number, any decimal
     * point is then removed (retaining the digits of any decimal part),
     * and the result is then converted to a <code>BigInteger</code>.
     *
     * @return The <code>java.math.BigInteger</code> equal in value to
     * this <code>BigDecimal</code> multiplied by ten to the
     * power of <code>this.scale()</code>.
     * @stable ICU 2.0
     */
    /* ActionScript : WONT PORT

     public java.math.BigInteger JavaDoc unscaledValue(){
     com.ibm.icu.math.BigDecimal res=null;
     if (exp>=0)
     res=this;
     else
     {
     res=clone(this); // safe copy
     res.exp=0; // drop scale
     }
     return res.toBigInteger();
     }

     /**
     * Translates a <code>double</code> to a <code>BigDecimal</code>.
     * <p>
     * Returns a <code>BigDecimal</code> which is the decimal
     * representation of the 64-bit signed binary floating point
     * parameter. If the parameter is infinite, or is not a number (NaN),
     * a <code>NumberFormatException</code> is thrown.
     * <p>
     * The number is constructed as though <code>num</code> had been
     * converted to a <code>String</code> using the
     * <code>Double.toString()</code> method and the
     * {@link #BigDecimal(java.lang.String)} constructor had then been used.
     * This is typically not an exact conversion.
     *
     * @param dub The <code>double</code> to be translated.
     * @return The <code>BigDecimal</code> equal in value to
     * <code>dub</code>.
     * @throws NumberFormatException if the parameter is infinite or
     * not a number.
     * @stable ICU 2.0
     */
    /* ActionScript : WONT PORT use constructor

     public static function valueOf(dub:Number):BigDecimal{
     // Reminder: a zero double returns '0.0', so we cannot fastpath to
     // use the constant ZERO. This might be important enough to justify
     // a factory approach, a cache, or a few private constants, later.
     return new BigDecimal(dub.toString());
     }
     */
    
    /* ---------------------------------------------------------------- */
    /* Private methods */
    /* ---------------------------------------------------------------- */
    
    /* <sgml> Carry out division operations. </sgml> */
    /*
     Arg1 is operation code: D=divide, I=integer divide, R=remainder
     Arg2 is the rhs.
     Arg3 is the context.
     Arg4 is explicit scale iff code='D' or 'I' (-1 if none).

     Underlying algorithm (complications for Remainder function and
     scaled division are omitted for clarity):

     Test for x/0 and then 0/x
     Exp =Exp1 - Exp2
     Exp =Exp +len(var1) -len(var2)
     Sign=Sign1 * Sign2
     Pad accumulator (Var1) to double-length with 0's (pad1)
     Pad Var2 to same length as Var1
     B2B=1st two digits of var2, +1 to allow for roundup
     have=0
     Do until (have=digits+1 OR residue=0)
     if exp<0 then if integer divide/residue then leave
     this_digit=0
     Do forever
     compare numbers
     if <0 then leave inner_loop
     if =0 then (- quick exit without subtract -) do
     this_digit=this_digit+1; output this_digit
     leave outer_loop; end
     Compare lengths of numbers (mantissae):
     If same then CA=first_digit_of_Var1
     else CA=first_two_digits_of_Var1
     mult=ca*10/b2b -- Good and safe guess at divisor
     if mult=0 then mult=1
     this_digit=this_digit+mult
     subtract
     end inner_loop
     if have\=0 | this_digit\=0 then do
     output this_digit
     have=have+1; end
     var2=var2/10
     exp=exp-1
     end outer_loop
     exp=exp+1 -- set the proper exponent
     if have=0 then generate answer=0
     Return to FINISHED
     Result defined by MATHV1

     For extended commentary, see DMSRCN.
     */
    
    private function dodivide(code : String, rhs : BigDecimal, context : MathContext, scale : Int) : BigDecimal
    {
        var lhs : BigDecimal;
        var reqdig : Int;
        var newexp : Int;
        var newlen : Int;
        var var1len : Int;
        var var2 : Array<Int>;
        var var2len : Int;
        var b2b : Int;
        var have : Int;
        var thisdigit : Int;
        var i : Int = 0;
        var v2 : Int = 0;
        var ba : Int = 0;
        var mult : Int;
        var start : Int;
        var padding : Int = 0;
        var d : Int = 0;
        var lasthave : Int = 0;
        var actdig : Int = 0;
		
		
		//trace('division scale 1', scale );

        
        if (context.lostDigits)
        {
            checkdigits(rhs, context.digits);
        }
        
        lhs = this;  // name for clarity  
        
        // [note we must have checked lostDigits before the following checks]
        if (rhs.ind == 0)
        {
            throw new ArithmeticError("Division by zero");
        }
        
        if (lhs.ind == 0)
        {
            if (scale == -1)
            {
                return lhs;
            }
            return lhs.setScale(scale);
        }
        
        /* Prepare numbers according to BigDecimal rules */
        reqdig = context.digits;  // local copy (heavily used)  
        
        if (reqdig > 0)
        {
            if (lhs.mant.length > reqdig)
            {
                lhs = clone(lhs).roundContext(context);
            }
            if (rhs.mant.length > reqdig)
            {
                rhs = clone(rhs).roundContext(context);
            }
        }
        else
        {
            /* scaled divide */
            if (scale == (-1))
            {
                scale = lhs.scale();
            }
            // set reqdig to be at least large enough for the computation
            reqdig = lhs.mant.length;  // base length  
			//trace('reqdig 0', reqdig);
            // next line handles both positive lhs.exp and also scale mismatch
            if (scale != (-lhs.exp))
            {
                reqdig = Std.int((reqdig + scale) + lhs.exp);
            }
			//trace('reqdig 1', reqdig, scale, lhs.exp);
            reqdig = Std.int((reqdig - rhs.mant.length - 1) - rhs.exp);  // reduce by RHS effect  
			//trace('reqdig 2', reqdig);
            if (reqdig < lhs.mant.length)
            {
                reqdig = lhs.mant.length;
            }
            if (reqdig < rhs.mant.length)
            {
                reqdig = rhs.mant.length;
            }
			//trace('reqdig 3', reqdig);
        }
        
        /* precalculate exponent */
        newexp = Std.int(((lhs.exp - rhs.exp) + lhs.mant.length) - rhs.mant.length);
        /* If new exponent -ve, then some quick exits are possible */
        if (newexp < 0)
        {
            if (code != "D")
            {
                if (code == "I")
                {
                    return ZERO;
                }
                /* Must be 'R'; remainder is [finished clone of] input value */
                return clone(lhs).finish(context);
            }
        }
		
		//trace('division scale 2', scale );
		
        
        /* We need slow division */
        var res : BigDecimal = new BigDecimal();  // where we'll build result  
        res.ind = (lhs.ind * rhs.ind);  // final sign (for D/I)  
        res.exp = newexp;  // initial exponent (for D/I)  
        res.mant = new Array<Int>();  // where build the result  
        
        /* Now [virtually pad the mantissae with trailing zeros */
        // Also copy the LHS, which will be our working array
        newlen = Std.int((reqdig + reqdig) + 1);
		//trace('reqdig + reqdig',reqdig , reqdig);
        
        var var1 : Array<Int> = padBy(lhs.mant, newlen - lhs.mant.length);
        //        var var1:Vector.<int> = lhs.mant.slice();
        //        var1.length = newlen; // always makes longer, so new safe array
        var1len = newlen;  // [remaining digits are 0]  
        
        var2 = rhs.mant;
        var2len = newlen;
        
        /* Calculate first two digits of rhs (var2), +1 for later estimations */
        b2b = Std.int((var2[0] * 10) + 1);
        if (var2.length > 1)
        {
            b2b = Std.int(b2b + var2[1]);
        }
        
        /* start the long-division loops */
        have = 0;
		
		//trace('division scale 3', scale, res.mant );
		
        
        var BREAK_outer : Bool = false;
        while (true)
        {
            thisdigit = 0;
            /* find the next digit */
            var BREAK_inner : Bool = false;
            while (true)
            {
				//trace('var1len < var2len', var1len < var2len, var1len, var2len);
                /*inner*/
                {
                    if (var1len < var2len)
                    {
                        BREAK_inner = true;
                        break  /*inner*/  ;
                    }
                    if (var1len == var2len)
                    {
                        // compare needed
                        var BREAK_compare : Bool = false;
                        // comparison
                        var __DOLLAR__22 : Int = var1len;
                        i = 0;
                                                while (__DOLLAR__22 > 0)
                        {
                            // var1len is always <= var1.length
                            if (i < var2.length)
                            {
                                v2 = var2[i];
                            }
                            else
                            {
                                v2 = 0;
                            }
                            if (var1[i] < v2)
                            {
                                BREAK_inner = BREAK_compare = true;
                                break;
                            }
                            if (var1[i] > v2)
                            {
                                BREAK_compare = true;
                                break;
                            }
                            __DOLLAR__22--;
                            i++;
                        }
                        if (!BREAK_compare)
                        {
                            /* reach here if lhs and rhs are identical; subtraction will
						 increase digit by one, and the residue will be 0 so we
						 are done; leave the loop with residue set to 0 (in case
						 code is 'R' or ROUND_UNNECESSARY or a ROUND_HALF_xxxx is
						 being checked) */
                            thisdigit++;
                            res.mant[have] = thisdigit;
                            have++;
                            var1[0] = 0;  // residue to 0 [this is all we'll test]  
                            // var1len=1 -- [optimized out]
                            BREAK_outer = BREAK_inner = BREAK_compare = true;
                            break;
                        }
                        /*compare*/
                        if (BREAK_inner)
                        {
                            break;
                        }
                        
                        /* prepare for subtraction. Estimate BA (lengths the same) */
                        ba = var1[0];
                    }
                    else
                    {
                        /* lengths the same */
                        {
                            /* lhs longer than rhs */
                            /* use first two digits for estimate */
                            ba = Std.int(var1[0] * 10);
                            if (var1len > 1)
                            {
                                ba = Std.int(ba + var1[1]);
                            }
                        }
                    }
                    
                    /* subtraction needed; V1>=V2 */
                    mult = Std.int(Std.int(ba * 10) / b2b);
                    if (mult == 0)
                    {
                        mult = 1;
                    }
                    thisdigit = Std.int(thisdigit + mult);
                    // subtract; var1 reusable
                    var1 = byteaddsub(var1, var1len, var2, var2len, -mult, true);
                    
                    if (var1[0] != 0)
                    {
                        continue  /*inner*/  ;
                    }
                    /* V1 now probably has leading zeros, remove leading 0's and try
                     again. (It could be longer than V2) */
                    var __DOLLAR__23 : Int = Std.int(var1len - 2);
                    start = 0;
                                        while (start <= __DOLLAR__23)
                    {
                        /* start */
                        {
                            if (var1[start] != 0)
                            {
                                break;
                            }
                            var1len--;
                        }
                        start++;
                    }
                    /*start*/
                    
                    if (start == 0)
                    {
                        continue  /*inner*/  ;
                    }
                    // shift left
                    for (i in 0...var1len)
                    {
                        var1[i] = var1[start + i];
                    }
                }
            }
            /*inner*/
            if (BREAK_outer)
            {
                break;
            }
            
            /* We have the next digit */
            if (have != 0 || thisdigit != 0)
            {
                // put the digit we got
                res.mant[have] = thisdigit;
                have++;
                if (have == (reqdig + 1))
                {
                    break  /*outer*/  ;
                }
                if (var1[0] == 0)
                {
                    break  /*outer*/  ;
                }
            }
            /* can leave now if a scaled divide and exponent is small enough */
            if (scale >= 0)
            {
                if ((-res.exp) > scale)
                {
                    break  /*outer*/  ;
                }
            }
            
            /* can leave now if not Divide and no integer part left */
            if (code != "D")
            {
                if (res.exp <= 0)
                {
                    break  /*outer*/  ;
                }
            }
            res.exp = res.exp - 1;  // reduce the exponent  
            /* to get here, V1 is less than V2, so divide V2 by 10 and go for
             the next digit */
            var2len--;
        }
        /*outer*/
        
		//trace('division scale 4', scale, res.mant  );
		
		
        /* here when we have finished dividing, for some reason */
        // have is the number of digits we collected in res.mant
        if (have == 0)
        {
            have = 1;
        }
        
        if (code == "I" || code == "R")
        {
			//trace('division scale 5.1', scale );
            /* check for integer overflow needed */
            if ((have + res.exp) > reqdig)
            {
                throw new Error("Integer overflow");
            }
            
            if (code == "R")
            {
                /*remainder*/
                {
                    /* We were doing Remainder -- return the residue */
                    if (res.mant[0] == 0)
                    {
                        // no integer part was found
                        return clone(lhs).finish(context);
                    }
                    if (var1[0] == 0)
                    {
                        return ZERO;
                    }
                    res.ind = lhs.ind;  // sign is always as LHS  
                    /* Calculate the exponent by subtracting the number of padding zeros
                     we added and adding the original exponent */
                    padding = Std.int(((reqdig + reqdig) + 1) - lhs.mant.length);
                    res.exp = (res.exp - padding) + lhs.exp;
                    
                    /* strip insignificant padding zeros from residue, and create/copy
                     the resulting mantissa if need be */
                    d = var1len;
                    i = Std.int(d - 1);
                                        while (i >= 1)
                    {
                        if (!((res.exp < lhs.exp) && (res.exp < rhs.exp)))
                        {
                            break;
                        }
                        if (var1[i] != 0)
                        {
                            break;
                        }
                        d--;
                        res.exp = res.exp + 1;
                        i--;
                    }
                    
                    if (d < var1.length)
                    {
                        /* need to reduce */
                        //as3hx.Compat.setArrayLength(var1, d);
                    }
                    res.mant = var1;
                    return res.finish(context);
                }
            }
        }
        else
        {
			//trace('division scale 5.2', scale );
			
            /* 'D' -- no overflow check needed */
            // If there was a residue then bump the final digit (iff 0 or 5)
            // so that the residue is visible for ROUND_UP, ROUND_HALF_xxx and
            // ROUND_UNNECESSARY checks (etc.) later.
            // [if we finished early, the residue will be 0]
            if (var1[0] != 0)
            {
                // residue not 0
                lasthave = res.mant[have - 1];
                if ((lasthave % 5) == 0)
                {
                    res.mant[have - 1] = (lasthave + 1);
                }
            }
			
			//trace('res.mant', res.mant);
        }
        
		//trace('division scale 6', scale );
		
        /* Here for Divide or Integer Divide */
        // handle scaled results first ['I' always scale 0, optional for 'D']
        if (scale >= 0)
        {
            /*scaled*/
            {
                // say 'scale have res.exp len' scale have res.exp res.mant.length
                if (have != res.mant.length)
                {
                    // already padded with 0's, so just adjust exponent
                    res.exp = res.exp - (res.mant.length - have);
                }
                // calculate number of digits we really want [may be 0]
                actdig = Std.int(res.mant.length - (-res.exp - scale));
                res.round(actdig, context.roundingMode);  // round to desired length  
                // This could have shifted left if round (say) 0.9->1[.0]
                // Repair if so by adding a zero and reducing exponent
                if (res.exp != -scale)
                {
                    res.mant[res.mant.length] = 0;  // extend by 1  
                    res.exp = res.exp - 1;
                }
                return res.finish(context);
            }
        }
        /*scaled*/
        
		//trace('division scale 7', scale );
		
        // reach here only if a non-scaled
        if (have == res.mant.length)
        {
            // got digits+1 digits
            res.roundContext(context);
        }
        else
        {
            /* have<=reqdig */
            if (res.mant[0] == 0)
            {
                return ZERO;
            }
            // make the mantissa truly just 'have' long
            // [we could let finish do this, during strip, if we adjusted
            // the exponent; however, truncation avoids the strip loop]
            // res.mant.length = have;
        }
		//trace('division scale 8', scale );
		        
        return res.finish(context);
    }
    
    /**
     * Returns the given exponent as an int, throwing an error if too large or small
     * @param exponent the value to convert to int
     * @return exponent as int337
	 * 
     */
    private static function toIntExponent(exponent : Float) : Int
    {
        if (exponent < Number.MIN_SAFE_INTEGER)
        {
            throw new ArithmeticError("Underflow");
        }
        else
        {
            if (exponent > Number.MAX_SAFE_INTEGER)
            {
                throw new ArithmeticError("Overflow");
            }
        }
        return Std.int(exponent);
    }
    
    /* <sgml> Add or subtract two >=0 integers in byte arrays
     <p>This routine performs the calculation:
     <pre>
     C=A+(B*M)
     </pre>
     Where M is in the range -9 through +9
     <p>
     If M<0 then A>=B must be true, so the result is always
     non-negative.

     Leading zeros are not removed after a subtraction. The result is
     either the same length as the longer of A and B, or 1 longer than
     that (if a carry occurred).

     A is not altered unless Arg6 is 1.
     B is never altered.

     Arg1 is A
     Arg2 is A length to use (if longer than A, pad with 0's)
     Arg3 is B
     Arg4 is B length to use (if longer than B, pad with 0's)
     Arg5 is M, the multiplier
     Arg6 is 1 if A can be used to build the result (if it fits)

     This routine is severely performance-critical; *any* change here
     must be measured (timed) to assure no performance degradation.
     */
    // 1996.02.20 -- enhanced version of DMSRCN algorithm (1981)
    // 1997.10.05 -- changed to byte arrays (from char arrays)
    // 1998.07.01 -- changed to allow destructive reuse of LHS
    // 1998.07.01 -- changed to allow virtual lengths for the arrays
    // 1998.12.29 -- use lookaside for digit/carry calculation
    // 1999.08.07 -- avoid multiply when mult=1, and make db an int
    // 1999.12.22 -- special case m=-1, also drop 0 special case
    
    private static function byteaddsub(a : Array<Int>, avlen : Int, b : Array<Int>, bvlen : Int, m : Int, reuse : Bool) : Array<Int>
    {
        // We'll usually be right if we assume no carry
        var alength : Int = a.length;  // physical lengths  
        var blength : Int = b.length;  // ..  
        var ap : Int = Std.int(avlen - 1);  // -> final (rightmost) digit  
        var bp : Int = Std.int(bvlen - 1);  // ..  
        var maxarr : Int = bp;
        
        if (maxarr < ap)
        {
            maxarr = ap;
        }
        
        var reb : Null<Array<Int>> = null;  // result byte array  
        if (reuse)
        {
            if ((maxarr + 1) == alength)
            {
                reb = a;
            }
        }
        if (reb == null)
        {
            reb = new Array<Int>();
        }
        
        var quickm : Bool = false;  // 1 if no multiply needed  
        if (m == 1)
        {
            quickm = true;
        }
        else
        {
            if (m == (-1))
            {
                quickm = true;
            }
        }
        
        var digit : Int = 0;  // digit, with carry or borrow  
        var op : Int = maxarr;
                while (op >= 0)
        {
            /*op*/
            {
                if (ap >= 0)
                {
                    if (ap < alength)
                    {
                        digit = Std.int(digit + a[ap]);
                    }
                    ap--;
                }
                if (bp >= 0)
                {
                    if (bp < blength)
                    {
                        // within B
                        if (quickm)
                        {
                            if (m > 0)
                            {
                                digit = Std.int(digit + b[bp]);
                            }
                            else
                            {
                                digit = Std.int(digit - b[bp]);
                            }
                        }
                        else
                        {
                            digit = Std.int(digit + (b[bp] * m));
                        }
                    }
                    bp--;
                }
                
                /* result so far (digit) could be -90 through 99 */
                if (digit < 10)
                {
                    if (digit >= 0)
                    {
                        /*quick*/
                        {
                            // 0-9
                            reb[op] = digit;
                            digit = 0;  // no carry  
                            {op--;continue;
                            }  /*op*/  
                        }
                    }
                }
                
                var dp90 : Int = Std.int(digit + 90);
                reb[op] = bytedig[dp90];  // this digit  
                digit = bytecar[dp90];
            }
            op--;
        }
        /*op*/
        
        if (digit == 0)
        {
            return reb;
        }
        // following line will become an Assert, later
        // if digit<0 then signal ArithmeticException("internal.error ["digit"]")
        
        /* We have carry -- need to make space for the extra digit */
        EcmaHX_Compat.arraySplice(reb, 0, 0, [digit]);
        return reb;
    }
    
    /* <sgml> Initializer for digit array properties (lookaside). </sgml>
     Returns the digit array, and initializes the carry array. */
    
    private static function diginit() : Array<Int>
    {
        var work : Array<Int> = new Array<Int>();
        var op : Int = 0;
                while (op <= (90 + 99))
        {
            /*op*/
            {
                var digit : Int = Std.int(op - 90);
                if (digit >= 0)
                {
                    work[op] = (digit % 10);
                    bytecar[op] = Std.int(digit / 10);  // calculate carry  
                    {op++;continue;
                    }  /*op*/  
                }
                
                // borrowing...
                digit = Std.int(digit + 100);  // yes, this is right [consider -50]  
                work[op] = (digit % 10);
                bytecar[op] = (Std.int(digit / 10) - 10);
            }
            op++;
        }
        /*op*/
        return work;
    }
    
    /* <sgml> Create a copy of BigDecimal object for local use.
     <p>This does NOT make a copy of the mantissa array.
     </sgml>
     Arg1 is the BigDecimal to clone (non-null)
     */
    
    private static function clone(dec : BigDecimal) : BigDecimal
    {
        var copy : BigDecimal = new BigDecimal(NULL);
        copy.ind = dec.ind;
        copy.exp = dec.exp;
        copy.mant = dec.mant;
        return copy;
    }
    
    /* <sgml> Check one or two numbers for lost digits. </sgml>
     Arg1 is RHS (or null, if none)
     Arg2 is current DIGITS setting
     returns quietly or throws an exception */
    
    private function checkdigits(rhs : BigDecimal, dig : Int) : Void
    {
        if (dig == 0)
        {
            return;
        }
        // first check lhs...
        if (mant.length > dig)
        {
            if (!allzero(mant, dig))
            {
                throw new Error("Too many digits: " + toString());
            }
        }
        if (rhs == null)
        {
            return;
        }
        if (rhs.mant.length > dig)
        {
            if (!allzero(rhs.mant, dig))
            {
                throw new Error("Too many digits: " + Std.string(rhs));
            }
        }
    }
    
    /* <sgml> Round to specified digits, if necessary. </sgml>
     Arg1 is requested MathContext [with length and rounding mode]
     returns this, for convenience */
    
    private function roundContext(context : MathContext) : BigDecimal
    {
        return round(context.digits, context.roundingMode);
    }
    
    /* <sgml> Round to specified digits, if necessary.
     Arg1 is requested length (digits to round to)
     [may be <=0 when called from format, dodivide, etc.]
     Arg2 is rounding mode
     returns this, for convenience

     ind and exp are adjusted, but not cleared for a mantissa of zero

     The length of the mantissa returned will be Arg1, except when Arg1
     is 0, in which case the returned mantissa length will be 1.
     </sgml>
     */
    
    private function round(len : Int, mode : Int) : BigDecimal
    {
        var adjust : Int;
        var sign : Int;
        var oldmant : Array<Int>;
        var reuse : Bool = false;
        var first : Int = 0;
        var increment : Int;
        var newmant : Array<Int> = null;
        
        adjust = Std.int(mant.length - len);
        if (adjust <= 0)
        {
            return this;
        }
        
        exp = toIntExponent(exp + adjust);  // exponent of result  
        sign = ind;  // save [assumes -1, 0, 1]  
        oldmant = mant;  // save  
		
		//trace(len, exp, sign, oldmant);
        
        if (len > 0)
        {
            // remove the unwanted digits
            mant = mant.slice(0, len);
            reuse = true;  // can reuse mantissa  
            first = oldmant[len];
        }
        else
        {
            /* len<=0 */
            mant = ZERO.mant;
            ind = iszero;
            reuse = false;  // cannot reuse mantissa  
            if (len == 0)
            {
                first = oldmant[0];
            }
            else
            {
                first = 0;
            }
        }
		
        
        // decide rounding adjustment depending on mode, sign, and discarded digits
        increment = 0;  // bumper  
        
        /*modes*/
        if (mode == MathContext.ROUND_HALF_UP)
        {
            // default first [most common]
            if (first >= 5)
            {
                increment = sign;
            }
        }
        else
        {
            if (mode == MathContext.ROUND_UNNECESSARY)
            {
                // default for setScale()
                // discarding any non-zero digits is an error
                if (!allzero(oldmant, len))
                {
                    throw new ArithmeticError("Rounding necessary");
                }
            }
            else
            {
                if (mode == MathContext.ROUND_HALF_DOWN)
                {
                    // 0.5000 goes down
                    if (first > 5)
                    {
                        increment = sign;
                    }
                    else
                    {
                        if (first == 5)
                        {
                            if (!allzero(oldmant, len + 1))
                            {
                                increment = sign;
                            }
                        }
                    }
                }
                else
                {
                    if (mode == MathContext.ROUND_HALF_EVEN)
                    {
                        // 0.5000 goes down if left digit even
                        if (first > 5)
                        {
                            increment = sign;
                        }
                        else
                        {
                            if (first == 5)
                            {
                                if (!allzero(oldmant, len + 1))
                                {
                                    increment = sign;
                                }
                                else
                                {
                                    /* 0.5000 */if (((mant[mant.length - 1]) % 2) == 1)
                                    {
                                        increment = sign;
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if (mode == MathContext.ROUND_DOWN)
                        {  // never increment  
                            
                        }
                        else
                        {
                            if (mode == MathContext.ROUND_UP)
                            {
                                // increment if discarded non-zero
                                if (!allzero(oldmant, len))
                                {
                                    increment = sign;
                                }
                            }
                            else
                            {
                                if (mode == MathContext.ROUND_CEILING)
                                {
                                    // more positive
                                    if (sign > 0)
                                    {
                                        if (!allzero(oldmant, len))
                                        {
                                            increment = sign;
                                        }
                                    }
                                }
                                else
                                {
                                    if (mode == MathContext.ROUND_FLOOR)
                                    {
                                        // more negative
                                        if (sign < 0)
                                        {
                                            if (!allzero(oldmant, len))
                                            {
                                                increment = sign;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        throw new ArgumentError("Bad round value: " + mode);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        /*modes*/
		
		trace('first', len, first, increment, mode == MathContext.ROUND_HALF_UP);

        if (increment != 0)
        {
            /*bump*/
            {
                if (ind == iszero)
                {
					trace('method 1');
                    // we must not subtract from 0, but result is trivial anyway
                    mant = ONE.mant;
                    ind = increment;
                }
                else
                {
					trace('method 2');
                    // mantissa is non-0; we can safely add or subtract 1
                    if (ind == isneg)
                    {
                        increment = -increment;
                    }
                    newmant = byteaddsub(mant, mant.length, ONE.mant, 1, increment, reuse);
                    if (newmant.length > mant.length)
                    {
                        // had a carry
                        // drop rightmost digit and raise exponent
                        exp++;
                        // mant is already the correct length
                        //as3hx.Compat.setArrayLength(newmant, mant.length);
                    }
                    mant = newmant;
                }
            }
        }
        /*bump*/
        return this;
    }
    
    /* <sgml> Test if rightmost digits are all 0.
     Arg1 is a mantissa array to test
     Arg2 is the offset of first digit to check
     [may be negative; if so, digits to left are 0's]
     returns 1 if all the digits starting at Arg2 are 0

     Arg2 may be beyond array bounds, in which case 1 is returned
     </sgml> */
    
    private static function allzero(array : Array<Int>, i : Int) : Bool
    {
        if (i < 0)
        {
            i = 0;
        }
        
        var len : Int = array.length;
                while (i < len)
        {
            if (array[i] != 0)
            {
                return false;
            }
            i++;
        }
        
        return true;
    }
    
    /**
     * Returns a copy of the given vector padded by pad extra zeroes
     * @param vec the vector to extend
     * @param pad the amount to pad by
     * @return a new vector
     */
    private static function padBy(vec : Array<Int>, pad : Int) : Array<Int>
    {
        var r : Array<Int> = vec.copy();
        //r.length += pad;
        if (vectorPadFix)
        {
            var last : Int = Std.int(r.length - 1);
                        while (pad-- > 0)
            {
                r[last - pad] = 0;
            }
        }
        return r;
    }
    
    /**
     * Returns true if we need to fix-up lengthened vectors with extra zeroes
	 * CA: made always return false
     */
    private static function needVectorPadFix() : Bool
    {
        // var version : Array<Dynamic> = Capabilities.version.split(" ")[1].split(",");
        // return version[0] == "10" && Std.int(version[1]) < 2;
		return false;
    }
    
    /* <sgml> Carry out final checks and canonicalization
     <p>
     This finishes off the current number by:
     1. Rounding if necessary (NB: length includes leading zeros)
     2. Stripping trailing zeros (if requested and \PLAIN)
     3. Stripping leading zeros (always)
     4. Selecting exponential notation (if required)
     5. Converting a zero result to just '0' (if \PLAIN)
     In practice, these operations overlap and share code.
     It always sets form.
     </sgml>
     Arg1 is requested MathContext (length to round to, trigger, and FORM)
     returns this, for convenience
     */
    
    private function finish(context : MathContext) : BigDecimal
    {
        /* Round if mantissa too long and digits requested */
        if (context.digits != 0)
        {
            if (mant.length > context.digits)
            {
                roundContext(context);
            }
        }
        
        /* Now check for leading- and all- zeros in mantissa */
        var len : Int = mant.length;
        for (i in 0...len)
        {
            /*i*/
            {
                if (mant[i] != 0)
                {
                    // non-0 result; ind will be correct
                    // remove leading zeros [e.g., after subtract]
                    if (i > 0)
                    {
                        /*delead*/
                        {
                            mant = mant.slice(i);
                        }
                    }
                    /*delead*/
                    
                    return this;
                }
            }
        }
        /*i*/
        
        // Drop through to here only if mantissa is all zeros
        ind = iszero;
        mant = ZERO.mant;  // canonical mantissa  
        return this;
    }
   
}

