package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI

/**
 * A utility class providing extension methods for IResources
 * 
 */
class IResourceUtil {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Creates and returns an EMF platform resource URI for the given Eclipse
	 * resource.
	 *
	 * @param iResource
	 *            an Eclipse resource
	 * @return a platform resource URI for the resource
	 */
	def static URI getEMFPlatformURI(IResource iResource) {
		return URI.createPlatformResourceURI(iResource.getFullPath()?.toString(), true)
	}
	
	def static String getAbsolutePathString(IResource resource) {
        return resource?.getLocation()?.toOSString()
    }
}