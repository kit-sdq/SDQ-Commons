package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.mdsdprofiles.api

import java.util.List
import org.eclipse.emf.ecore.EObject

import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.EObjectUtil.getFeatureValues
import static extension edu.kit.ipd.sdq.commons.util.java.util.ListUtil.mapFixed
import static extension org.palladiosimulator.mdsdprofiles.api.StereotypeAPI.*
import org.modelversioning.emfprofileapplication.StereotypeApplication
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for stereotypable EObjects.<br/><br/>
 * 
 * For best results, all stereotypes of a profile should be designed as follows:
 * Stereotypes should only define attributes and non-containment references to
 * metaclasses of an extension metamodel. As a result, stereotype applications 
 * only act as "glue" that directly add simple-typed values or indirectly add
 * complex-typed values that are already persisted in an instance of the extension metamodel.<br/><br/>
 * 
 * If this best practice is followed, the only methods that are necessary to add and access all 
 * information that is added using stereotypes are
 * {@link StereotypeAPIUtil#getTaggedValues(EObject, String, String, Class) getTaggedValues} and
 * {@link StereotypeAPIUtil#addTaggedValues(EObject, String, String, List, Class) addTaggedValues}.<br/><br/>
 * 
 * Consumers of this API do not need to know about the internal realization
 * using {@link org.modelversioning.emfprofileapplication.StereotypeApplication StereotypeApplication}
 * and {@link org.modelversioning.emfprofile.Stereotype Stereotype}.
 */
@Utility
class StereotypeAPIUtil {
	/**
	 * Returns all values that are currently tagged to the given {@link eObject} via 
	 * applications of stereotypes that have the given {@link stereotypeName} using a feature
	 * with the given {@link featureName}. That is, the returned values are those that are set for the 
	 * stereotype feature with the given {@link featureName} in applications of the stereotype
	 * with the given {@link stereotypeName}, such that the applications extend the given {@link eObject}.
	 * All these values have to be assignment-compatible to the given {@link tagType}.<br/><br/>
	 * 
	 * @param eObject the object for which tagged values shall be retrieved
	 * @param stereotypeName the name of the stereotype that is applied to the {@link eObject}
	 * @param featureName the name of the attribute or reference that is defined for the stereotype and for which tagged values shall be retrieved
	 * @param tagType the type of the tagged values
	 */
	def static <T> List<T> getTaggedValues(EObject eObject, String stereotypeName, String featureName, Class<T> tagType) {
		val stereotypeApplications = eObject.getStereotypeApplications(stereotypeName)
		val taggedValues = stereotypeApplications.getTaggedValues(featureName, tagType)
		return taggedValues
	}
	
	def static <T> List<T> getTaggedValues(Iterable<StereotypeApplication> applications, String featureName, Class<T> tagType) {
		return applications.mapFixed[it.getFeatureValues(featureName)].flatten().mapFixed[tagType.cast(it)]
	}
	
	/**
	 * Adds the given {@link taggedValuesToAdd} as tags to the given {@link eObject} 
	 * using the given {@link featureName} by either newly applying the stereotype 
	 * with the given {@link stereotypeName} or by using an existing application of it.
	 * That is, the added values are set for the stereotype feature with the given {@link featureName} 
	 * in an applications of the stereotype with the given {@link stereotypeName}, 
	 * such that the application extends the given {@link eObject}.
	 * All {@link taggedValuesToAdd} have to be assignment-compatible to the given {@link tagType}.<br/><br/>
	 * 
	 * @param eObject the object for which tagged values shall be added
	 * @param stereotypeName the name of the stereotype that shall be applied to the {@link eObject}, if necessary
	 * @param featureName the name of the attribute or reference that is defined for the stereotype and for which tagged values shall be added
	 * @param taggedValuesToAdd the values to be tagged to the given {@link eObject}
	 * @param tagType the type of the tagged values
	 */
	def static <T> List<T> addTaggedValues(EObject eObject, String stereotypeName, String featureName, List<T> taggedValuesToAdd, Class<T> tagType) {
		val alreadyApplied = eObject.isStereotypeApplied(stereotypeName)
		if (!alreadyApplied) {
			eObject.applyStereotype(stereotypeName)
		}
		// MDSD Profiles is implemented in a way that "guarantees" that there is always only a single stereotype application per EObject
		val taggedValues = eObject.getStereotypeApplications(stereotypeName)?.get(0)?.getFeatureValues(featureName).mapFixed[tagType.cast(it)]
		taggedValuesToAdd.forEach[taggedValues.add(it)]
		return taggedValues
	}
}
