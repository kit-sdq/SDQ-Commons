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
}