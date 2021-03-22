package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import org.eclipse.core.resources.IResource
import edu.kit.ipd.sdq.activextendannotations.Utility
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.CoreException

/**
 * A utility class providing extension methods for IResources
 * 
 */
@Utility
class IResourceUtil {
	def static String getAbsolutePathString(IResource resource) {
		return resource?.getLocation()?.toOSString()
	}

	def static IFolder createIfNotExists(IFolder folder) {
		try {
			folder.create(false, true, null)
		} catch (CoreException e) {
			if (!e.message.contains('already exists')) throw e
		}
		return folder
	}
}
