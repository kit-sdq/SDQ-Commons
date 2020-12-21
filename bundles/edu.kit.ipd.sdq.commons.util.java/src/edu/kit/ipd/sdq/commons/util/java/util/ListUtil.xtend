package edu.kit.ipd.sdq.commons.util.java.util

import java.util.List
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for Lists
 */
@Utility
class ListUtil {
	/**
	 * Returns the element at the given index and throws an {@link java.lang.IllegalStateException} if it is not existing.
	 */
	def static <T> T claimElementAt(List<T> list, int index) {
		val element = list?.get(index)
		if (element === null) {
			throw new IllegalStateException("It was claimed that the list '" + list + "' contains an element at index '" + index + "'!")
		} else {
			return element
		}
	}
}