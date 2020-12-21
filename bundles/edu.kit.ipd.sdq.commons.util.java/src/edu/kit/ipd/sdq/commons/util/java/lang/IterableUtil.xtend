package edu.kit.ipd.sdq.commons.util.java.lang

import java.util.List
import java.util.ArrayList
import java.util.function.Predicate
import java.util.Map
import java.util.HashMap
import java.util.Collection
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for Iterables
 */
@Utility
class IterableUtil {
	static final def <T, R> List<R> mapFixed(Iterable<T> original, (T)=>R transformation) {
		val target = if (original instanceof Collection<?>) new ArrayList(original.size) else new ArrayList()
		mapFixedTo(original, target, transformation)
	}

	static final def <T, R> List<R> mapFixed(Collection<T> original, (T)=>R transformation) {
		mapFixedTo(original, new ArrayList(original.size), transformation)
	}

	static final def <T, R, C extends Collection<R>> C mapFixedTo(Iterable<T> original, C target,
		(T)=>R transformation) {
		for (T o : original) {
			target.add(transformation.apply(o))
		}
		return target
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
	static final def String join(Iterable<? extends CharSequence> iterable, CharSequence before, CharSequence separator,
		CharSequence after) '''«FOR cs : iterable BEFORE before SEPARATOR separator AFTER after»«cs»«ENDFOR»'''

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

	/**
	 * Checks if the given {@link Iterable} contains only one element and returns it.
	 * Otherwise, an exception is thrown.
	 * 
	 * @param iterable -
	 * 		the {@link Iterable}. May not be <code>null</code>.
	 * @return the only element in the given {@link Iterable}. Never <code>null</code>.
	 * 
	 * @throws IllegaStateException if the given {@link Iterable} does not contain exactly one element
	 */
	def static final <A extends Iterable<T>, T> T claimOne(A iterable) {
		val iterator = iterable.iterator();
		if (iterator.hasNext()) {
			val one = iterator.next();
			if (!iterator.hasNext()) {
				return one;
			}
		}
		throw new IllegalStateException("It was claimed that the collection '" + iterable +
			"' contains exactly one element!");
	}

	/**
	 * Checks if the given {@link Iterable} is empty.
	 * Otherwise, an exception is thrown.
	 * 
	 * @param iterable -
	 * 		the {@link Iterable}. May not be <code>null</code>.
	 * @return the given {@link Iterable}.
	 * 
	 * @throws IllegaStateException if the given {@link Iterable} is empty
	 */
	def static final <A extends Iterable<?>> A claimNotEmpty(A iterable) {
		if (iterable.size() == 0) {
			throw new IllegalStateException("It was claimed that the collection '" + iterable + "' is not empty!");
		}
		return iterable;
	}

	/**
	 * Checks if the given {@link Iterable} contains at most one element and returns it.
	 * If it contains more than 1 element, an exception is thrown.
	 * 
	 * @param iterable -
	 * 		the {@link Iterable}. May not be <code>null</code>.
	 * @return the unique element of the given {@link Iterable} or <code>null</code> if it is empty.
	 * 
	 * @throws IllegaStateException if the given {@link Iterable} contains more than one element
	 */
	def static final <A extends Iterable<T>, T> T claimNotMany(A c) {
		val size = c.size();
		if (size > 1) {
			throw new IllegalStateException("It was claimed that the collection '" + c +
				"' contains exactly one element!");
		} else if (size == 1) {
			return c.iterator().next();
		} else {
			return null;
		}
	}

	/**
	 * Queries whether the given iterable contains any element fulfilling the
	 * provided predicate.
	 */
	def static <T> containsAny(Iterable<T> iterable, Predicate<? super T> predicate) {
		for (T t : iterable) {
			if (predicate.test(t)) {
				return true
			}
		}
		return false
	}

	/**
	 * Returns a map whose values are the {@code iterable}’s values. The map’s
	 * keys will be computed by invoking the supplied function {@code indexer}
	 * on each value corresponding value. Each key should be unique throughout
	 * the {@code iterable}. If it’s not, values override earlier values with
	 * the same key 
	 * 
	 * @param iterable
	 * 		the values to use when constructing the {@code Map}. May not
	 * 		be {@code null}.
	 * @param indexer
	 * 		the function used to produce the key for each value. May not
	 * 		be {@code null}.
	 * @return a map mapping the result of evaluating the function 
	 * 		{@code indexer} on each value in the input iterable to that 
	 * 		value.
	 */
	def static <A, B> Map<A, B> indexedBy(Iterable<B> iterable, (B)=>A indexer) {
		val result = if (iterable instanceof Collection<?>) {
				new HashMap(iterable.size)
			} else {
				new HashMap
			}
		for (b : iterable) {
			result.put(indexer.apply(b), b)
		}
		return result
	}
}
