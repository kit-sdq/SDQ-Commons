package edu.kit.ipd.sdq.commons.util.java.lang

import org.eclipse.xtext.xbase.lib.Functions.Function1
import java.util.List
import java.util.ArrayList

/**
 * A utility class providing extension methods for Iterables
 * 
 */
class IterableUtil {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	public static final def <T, R> List<R> mapFixed(Iterable<T> original, Function1<? super T, ? extends R> transformation) {
		val List<R> list = new ArrayList()
		for (T o : original) {
			list.add(transformation.apply(o))
		}
		return list
	}
	
	/**
	 * Returns the concatenated string representation of the elements in the given iterable. 
	 * The {@code separator} is used to between each pair of entries in the input.
	 * 
	 * @param iterable
	 *            the iterable. May not be <code>null</code>.
	 * @param before
	 *            prepends the resulting string if the iterable contains at least one element. May be <code>null</code> which is equivalent to passing an empty string.
	 * @param separator
	 *            the separator. May be <code>null</code> which is equivalent to passing an empty string.
	 * @param after
	 *            appended to the resulting string if the iterable contain at least one element. May be <code>null</code> which is equivalent to passing an empty string.
	 * @return the string representation of the iterable's elements. Never <code>null</code>.
	 *
	 * @see org.eclipse.xtext.xbase.lib.IterableExtensions#join(Iterable, CharSequence, CharSequence, CharSequence, Functions.Function1)
	 */
	public static final def String join(Iterable<? extends CharSequence> iterable, CharSequence before, CharSequence separator, CharSequence after) '''«
	FOR cs : iterable
		BEFORE before
		SEPARATOR separator
		AFTER after
		»«cs»«
	ENDFOR»'''
	
	/**
	 * Returns the number of times the element occurs in the collection.
	 */
	def static <T> int count(Iterable<T> coll, T element) {
		var count = 0
		for (T pivot : coll) {
			if (pivot == element) {
				count++
			}
		}
		return count
	}
}