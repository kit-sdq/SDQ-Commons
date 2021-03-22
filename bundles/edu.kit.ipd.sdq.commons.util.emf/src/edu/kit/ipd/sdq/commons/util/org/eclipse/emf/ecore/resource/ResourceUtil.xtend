package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import edu.kit.ipd.sdq.activextendannotations.Utility
import static com.google.common.base.Preconditions.checkArgument
import static com.google.common.base.Preconditions.checkState
import java.util.List

@Utility
class ResourceUtil {
	 /**
     * Returns an {@link Iterable} for iterating over all direct and indirect contents of the given {@link Resource}.
     *
     * @param resource -
     *		the {@link Resource} to get the contents {@link Iterable} for
     * @return a direct and indirect contents iterating {@link Iterable}
     *
     * @see org.eclipse.emf.ecore.Resource#eAllContents() Resource.eAllContents()
     */
    def static Iterable<EObject> getAllContentsIterable(Resource resource) {
    	checkArgument(resource !== null, "resource must not be null")
        return resource.allContents.toIterable()
    }
    
    /** 
	 * Returns the first root element of the given {@link Resource}. It is <i>not</i> necessary to have exactly 
	 * one root element. If there is not at least one root element, an {@link IllegalStateException} is thrown.
	 * 
	 * @param resource -
	 *		a {@link Resource} to retrieve the first root element from
	 * @return the root element
	 */
	def static EObject getFirstRootEObject(Resource resource) {
		checkArgument(resource !== null, "resource must not be null")
		checkState(resource.getContents().size() >= 1, '''resource %s does not contain a root element''', resource.URI) 
		return resource.contents.get(0)
	}
	
	/**
	 * Retrieves all proxy {@link EObject}s referenced within the given {@link Resource}, i.e. elements being proxies
	 * that are referenced by any element contained within the given {@link Resource}	 * 
	 * 
	 * @param resource - 
	 *		the resource to find the referenced proxy elements in
	 * @return the proxy elements referenced in the given {@link Resource}
	 */
	def static Iterable<EObject> getReferencedProxies(Resource resource) {
		checkArgument(resource !== null, "resource must not be null")
		resource.allContents.toIterable.flatMap[object | object.eClass.EReferences.flatMap[
			val contents = object.eGet(it);
			return switch contents { 
				List<EObject>: contents 
				EObject: List.of(contents)
				default: emptyList
			}
		].filter[eIsProxy]].toList
	}
	
}