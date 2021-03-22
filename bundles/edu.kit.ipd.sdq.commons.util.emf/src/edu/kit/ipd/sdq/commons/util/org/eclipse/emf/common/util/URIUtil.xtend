package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.common.util

import org.eclipse.emf.common.util.URI
import org.eclipse.core.resources.IFile
import java.io.File
import org.eclipse.core.runtime.IPath
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path
import edu.kit.ipd.sdq.activextendannotations.Utility
import org.eclipse.core.resources.IResource

/**
 * A utility class providing extension methods for EObjects
 */
@Utility
class URIUtil {
	/**
	 * Return whether a resource exists at the specified {@link URI}. The given {@link URI} must be either a file or a platform URI.
	 * 
	 * @param uri -
	 * 		an EMF {@link URI} of type file or platform
	 * @return true if a resource exists at the {@link URI}, false otherwise
	 */
	def static boolean existsResourceAtUri(URI uri) {
		if (uri.isPlatform()) {
			if (uri.isPlatformPlugin()) {
				throw new UnsupportedOperationException();
			}
			return getIFileForEMFUri(uri).exists()
		} else if (uri.isFile()) {
			return new File(uri.toFileString()).exists()
		}
		throw new UnsupportedOperationException(
			"Checking if a resource at an URI exists is currently only implemented for file and platform URIs.");
	}

	/**
	 * Returns an Eclipse file for the given EMF URI. The given {@link URI} must be a platform URI.
	 * 
	 * @param uri -
	 * 		an EMF {@link URI} of type platform
	 * @return an Eclipse file for the given {@link URI}
	 */
	def static IFile getIFileForEMFUri(URI uri) {
		if (uri.isPlatform()) {
			val path = getIPathForEMFUri(uri)
			if (uri.isPlatformPlugin()) {
				throw new UnsupportedOperationException();
			}
			return ResourcesPlugin.getWorkspace().getRoot().getFile(path)
		}
		throw new UnsupportedOperationException("Getting the IFile is currently only implemented for platform URIs.");
	}

	/**
	 * Creates and returns a new Eclipse path for the given EMF URI. The given {@link URI} must be either a file or a platform URI.
	 * 
	 * @param uri -
	 *		an EMF {@link URI} of type file or platform
	 * @return a new Eclipse {@IPath} for the given {@link URI}
	 */
	def static IPath getIPathForEMFUri(URI uri) {
		if (uri.isPlatform()) {
			return new Path(uri.toPlatformString(true))
		} else if (uri.isFile()) {
			return new Path(uri.toFileString())
		}
		throw new UnsupportedOperationException(
			"Getting the path is currently only implemented for file and platform URIs.");
	}

	/**
	 * Returns whether the given {@link URI} is a pathmap URI or not.
	 * 
	 * @param uri -
	 *		an EMF {@ink URI}
	 * @return <code>true</code> if the given {@link  URI} is a pathmap URI, <code>false</code> otherwise
	 */
	def static boolean isPathmap(URI uri) {
		return uri.toString.startsWith("pathmap");
	}

	/**
	 * Creates and returns an EMF file {@link URI} for the given {@link File}.
	 * 
	 * @param file -
	 * 		the file to get the EMF {@link URI} for
	 * @return the EMF file URI for the given {@link File}
	 */
	static def URI createFileURI(File file) {
		return URI.createFileURI(file.getAbsolutePath());
	}
	
	/**
	 * Creates and returns an EMF platform resource {@link URI} for the given Eclipse
	 * {@link IResource}.
	 * 
	 * @param iResource -
	 * 		an Eclipse {@link IResource}
	 * @return a platform resource {@link URI} for the {@link IResource}
	 */
	def static URI createPlatformResourceURI(IResource iResource) {
		return URI.createPlatformResourceURI(iResource.getFullPath()?.toString(), true)
	}
	
}
