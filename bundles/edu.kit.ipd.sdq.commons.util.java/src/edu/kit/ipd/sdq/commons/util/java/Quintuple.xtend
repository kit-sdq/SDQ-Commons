package edu.kit.ipd.sdq.commons.util.java

import org.eclipse.xtend.lib.annotations.Data

/**
 * A 4-tuple.
 *
 * @param <A>
 *            the type of the first element
 * @param <B>
 *            the type of the second element
 * @param <C>
 *            the type of the third element
 * @param <D>
 *            the type of the fourth element
 * @param <E>
 *            the type of the fifth element
 * @author Max E. Kramer
 */
 @Data
class Quintuple<A,B,C,D,E> extends Quadruple<A,B,C,D> {
	E fifth
	
    /**
     * @return the element at zero-based index 4, which is also available via the getter {@link E getFifth()}
     */
	def E get4() {
    	return fifth
    }
	
	override toString() '''Quintuple(«this.first»,«this.second»,«this.third»,«this.fourth»,«this.fifth»)'''
}