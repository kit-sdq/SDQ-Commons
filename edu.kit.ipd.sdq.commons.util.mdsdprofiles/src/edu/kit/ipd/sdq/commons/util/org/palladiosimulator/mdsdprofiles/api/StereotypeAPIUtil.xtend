package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.mdsdprofiles.api

import java.util.List
import org.eclipse.emf.ecore.EObject

import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.EObjectUtil.getFeatureValues
import static extension edu.kit.ipd.sdq.commons.util.java.util.ListUtil.mapFixed
import static extension org.palladiosimulator.mdsdprofiles.api.StereotypeAPI.getStereotypeApplications

/**
 * A utility class providing extension methods for stereotypable EObjects
 * 
 */
class StereotypeAPIUtil {
	 /** Utility classes should not have a public or default constructor. */
	private new() {
	}

	def static <T> List<T> getTaggedValues(EObject eObject, String stereotypeName, String featureName, Class<T> clazz) {
		val stereotypeApplications = eObject.getStereotypeApplications(stereotypeName)
		val taggedValues = stereotypeApplications.mapFixed[it.getFeatureValues(featureName)].flatten().mapFixed[clazz.cast(it)]
		return taggedValues
	}
}
