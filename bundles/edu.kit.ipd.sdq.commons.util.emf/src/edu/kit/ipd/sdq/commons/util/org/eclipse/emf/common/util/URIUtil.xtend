package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.common.util

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import java.util.Collections
import java.util.Map
import java.io.IOException
import org.eclipse.core.resources.IFile
import java.io.File
import org.eclipse.core.runtime.IPath
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path

/**
 * A utility class providing extension methods for EObjects
 * 
 */
class URIUtil {
	 /** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	def static Resource loadResourceAtURI(URI resourceURI, ResourceSet resourceSet) {
		return loadResourceAtURI(resourceURI, resourceSet, Collections.emptyMap())
	}

	def static Resource loadResourceAtURI(URI resourceURI, ResourceSet resourceSet, Map<Object, Object> loadOptions) {
		var Resource resource = null
		try {
			var normalizedURI = resourceURI
			if (!resourceURI.isFile() && !resourceURI.isPlatform()) {
				normalizedURI = resourceSet.getURIConverter().normalize(resourceURI)
			}

			if (resourceSet.URIConverter.exists(normalizedURI, null)) {
				resource = resourceSet.getResource(normalizedURI, true);
			}

			if (resource === null) {
				val oldResource = resourceSet.getResource(normalizedURI, false);
				if (oldResource !== null) {
					oldResource.delete(null);
				}
				resource = resourceSet.createResource(normalizedURI);
			} else {
				resource.load(loadOptions);
			}

			// Fixes issue caused by JaMoPP: If a model is transitively loaded
			// (e.g. because of an import) the URI starts with pathmap instead
			// of
			// the usual URI. If you try to load this model again the URI
			// remains wrong.
			resource.setURI(normalizedURI);
		} catch (IOException e) {
			// soften
			throw new RuntimeException(e);
		}
		return resource;
	}
	
	/**
	 * Return whether a resource exists at the specified {@link URI}. The given {@link URI} must be either a file or a platform URI.
	 * 
	 * @param uri
	 *            an EMF URI of type file or platform
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
	 * @param uri
	 *            an EMF URI of type platform
	 * @return an Eclipse file for the given URI
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
	 * @param uri
	 *            an EMF URI of type file or platform
	 * @return a new Eclipse path for the given URI
	 */
	def static IPath getIPathForEMFUri(URI uri) {
		if (uri.isPlatform()) {
			return new Path(uri.toPlatformString(true))
		} else if (uri.isFile()) {
			return new Path(uri.toFileString())
		}
		throw new UnsupportedOperationException("Getting the path is currently only implemented for file and platform URIs.");
	}
	
	/**
	 * Returns whether the given {@link URI} is a pathmap URI or not.
	 * 
	 * @param uri
	 * 			an EMF URI
	 * @return <code>true</code> if the given {@link  URI} is a pathmap URI, <code>false</code> otherwise
	 */
	def static boolean isPathmap(URI uri) {
		return uri.toString.startsWith("pathmap");
	}
}