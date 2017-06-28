package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource

class ResourceUtil {
	 /**
     * Returns an iterable for iterating over all direct and indirect contents of the given Resource.
     *
     * @param resource
     *            container Resource
     * @return a direct and indirect content iterating iterable
     *
     * @see org.eclipse.emf.ecore.Resource#eAllContents() Resource.eAllContents()
     */
    def static Iterable<EObject> getAllContentsIterable(Resource resource) {
        return resource.getAllContents().toIterable();
    }
}