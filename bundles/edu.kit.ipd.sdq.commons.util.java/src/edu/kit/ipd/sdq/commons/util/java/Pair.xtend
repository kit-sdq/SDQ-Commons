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
class Pair<A,B> extends Monuple<A> {
    B second	
    
    /**
     * @return the element at zero-based index 1, which is also available via the getter {@link B getSecond()}
     */
    def B get1() {
    	return second
    }
    
    override toString() '''Pair(«this.first»,«this.second»)'''
}