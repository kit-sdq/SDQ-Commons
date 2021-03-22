package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource

import edu.kit.ipd.sdq.activextendannotations.Utility
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.common.util.URI
import java.io.FileNotFoundException

@Utility
class ResourceSetUtil {
	/**
	 * Registers the global map for between file extensions and factories at the given
	 * {@link ResourceSet}.
	 * 
	 * @param resourceSet -
	 * 			the {@link ResourceSet} to register the global file extension mapping at
	 * @return the input
	 */
	def static withGlobalFactories(ResourceSet resourceSet) {
		resourceSet => [
			resourceFactoryRegistry.extensionToFactoryMap += Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
			resourceFactoryRegistry.extensionToFactoryMap += "*" -> new XMIResourceFactoryImpl()
		]
	}

	/** 
	 * Returns a {@link Resource} that is either already loaded into and retrieved from
	 * the given {@link ResourceSet}, or creates a new {@link Resource} if it does 
	 * not exist yet.
	 * 
	 * @param resourceSet -
	 * 			the {@link ResourceSet} to load the {@link Resource} into
	 * @param uri -
	 * 			the {@link URI} of the {@link Resource} to get or create
	 * @return a {@link Resource} created for or retrieved from the given {@link URI}
	 */
	def static Resource getOrCreateResource(ResourceSet resourceSet, URI uri) {
		var resource = resourceSet.getResource(uri, false)
		if (resource === null) {
			resource = resourceSet.createResource(uri)
		}
		return resource
	}

	/** 
	 * Returns a {@link Resource} that is either loaded from the given {@link URI} if some model 
	 * is persisted at that {@link URI}, or creates a new{@link Resource} if it does not exist yet.
	 * 
	 * @param resourceSet -
	 * 			the {@link ResourceSet} to load the {@link Resource} into
	 * @param uri -
	 * 			the {@link URI} of the {@link Resource} to load
	 * @return a {@link Resource} created for or loaded from the given {@link URI}
	 * @throws RuntimeException if some exception occurred during loading the file
	 */
	def static Resource loadOrCreateResource(ResourceSet resourceSet, URI uri) throws RuntimeException {
		try {
			return resourceSet.getResource(uri, true)
		} catch (RuntimeException e) {
			// EMF failed during demand creation, usually because the file did not exist. If
			// it has created an empty resource, retrieve it.
			// If the file does not exist, depending on the URI type not only a
			// FileNotFoundException, but at least also a ResourceException can occur. Since
			// it that exception is internal, we match the message ("not exist") instead.
			if (e.getCause() instanceof FileNotFoundException || e.getMessage().contains("not exist")) {
				return resourceSet.getResource(uri, false)
			} else {
				throw e
			}
		}
	}

}
