package edu.kit.ipd.sdq.commons.util.java

import org.eclipse.xtend.lib.annotations.Data

/**
 * A 3-tuple (also called triplet).
 *
 * @param <A>
 *            the type of the first element
 * @param <B>
 *            the type of the second element
 * @param <C>
 *            the type of the third element
 * @author Max E. Kramer
 */
@Data
class Triple<A,B,C> extends Pair<A,B> {
	C third
	
	override toString() '''Triple(«this.first»,«this.second»,«this.third»)'''
}