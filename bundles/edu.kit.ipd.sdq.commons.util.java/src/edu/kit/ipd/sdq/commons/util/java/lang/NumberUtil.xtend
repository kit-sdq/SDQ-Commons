package edu.kit.ipd.sdq.commons.util.java.lang

import java.math.BigDecimal
import java.math.BigInteger

/**
 * A utility class providing extension methods for Numbers
 * 
 */
class NumberUtil {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns the sum of all numbers in the collection 
	 * if all of them are of one of the following types: 
	 * BigDecimalBigInteger, Byte, Double, Float, Integer, Long, or Short
	 * and throws an UnsupportedOperationException otherwise.
	 */
	def static Number sum(Iterable<? extends Number> coll) {
		var Number sum = null
		for (Number number : coll) {
			if (sum == null) {
				sum = number
			} else {
// 				FIXME find out the partial order for the supported Number types, which are
//				BigDecimal
//				BigInteger
//				Byte
//				Double
//				Float
//				Integer
//				Long
//				Short
//				and call appropriate casting methods such as BigDecimal.valueOf
//				before summing up!
				sum = NumberUtil.operator_plus(sum, number)
			}
		}
		return sum
	}
	
	def static dispatch operator_plus(Number n1, Number n2) {
		throw new UnsupportedOperationException()
	}
	
	def static dispatch operator_plus(BigDecimal n1, BigDecimal n2) {
		return BigDecimalExtensions.operator_plus(n1,n2)
	}
	
	def static dispatch operator_plus(BigInteger n1, BigInteger n2) {
		return BigIntegerExtensions.operator_plus(n1,n2)
	}
	
	def static dispatch operator_plus(Byte n1, Byte n2) {
		return ByteExtensions.operator_plus(n1,n2)
	}

	def static dispatch operator_plus(Double n1, Double n2) {
		return DoubleExtensions.operator_plus(n1,n2)
	}

	def static dispatch operator_plus(Float n1, Float n2) {
		return FloatExtensions.operator_plus(n1,n2)
	}

	def static dispatch operator_plus(Integer n1, Integer n2) {
		return IntegerExtensions.operator_plus(n1,n2)
	}

	def static dispatch operator_plus(Long n1, Long n2) {
		return LongExtensions.operator_plus(n1,n2)
	}

	def static dispatch operator_plus(Short n1, Short n2) {
		return ShortExtensions.operator_plus(n1,n2)
	}
}