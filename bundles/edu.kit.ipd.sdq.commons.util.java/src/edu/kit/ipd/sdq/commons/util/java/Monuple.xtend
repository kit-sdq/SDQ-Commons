package edu.kit.ipd.sdq.commons.util.java

import org.eclipse.xtend.lib.annotations.Data

/**
 * A monuple (also called single or singleton).
 *
 * @param <A>
 *            the type of the first element
 * @author Max E. Kramer
 */
@Data
class Monuple<A> {
    A first	
    
    /**
     * @return the element at zero-based index 0, which is also available via the getter {@link A getFirst()}
     */
    def A get0() {
    	return first
    }
    
    override toString() '''Monuple(«this.first»)'''
}