package edu.kit.ipd.sdq.commons.util.java.util

import java.util.List

/**
 * A utility class providing extension methods for Lists
 * 
 */
class ListUtil {
	
	 /** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns the element at the given index and throws an {@link java.lang.IllegalStateException} if it is not existing.
	 */
	def static <T> T claimElementAt(List<T> list, int index) {
		val element = list?.get(index)
		if (element == null) {
			throw new IllegalStateException("It was claimed that the list '" + list + "' contains an element at index '" + index + "'!")
		} else {
			return element
		}
	}
}