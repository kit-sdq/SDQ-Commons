package edu.kit.ipd.sdq.commons.util.java

import org.eclipse.xtend.lib.annotations.Data

/**
 * A 2-tuple (also called double).
 *
 * @param <A>
 *            the type of the first element
 * @param <B>
 *            the type of the second element
 * @author Max E. Kramer
 */
@Data
class Pair<A,B> {
    A first
    B second	
    
    override toString() '''Pair(«this.first»,«this.second»)'''
}