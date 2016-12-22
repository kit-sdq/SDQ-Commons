package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.mdsdprofiles.api

import java.util.List
import org.eclipse.emf.ecore.EObject

import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.EObjectUtil.getFeatureValues
import static extension edu.kit.ipd.sdq.commons.util.java.util.ListUtil.mapFixed
import static extension org.palladiosimulator.mdsdprofiles.api.StereotypeAPI.*


/**
 * A utility class providing extension methods for stereotypable EObjects
 * 
 */
class StereotypeAPIUtil {
	 /** Utility classes should not have a public or default constructor. */
	private new() {
	}

	def static <T> List<T> getTaggedValues(EObject eObject, String stereotypeName, String featureName, Class<T> tagType) {
		val stereotypeApplications = eObject.getStereotypeApplications(stereotypeName)
		val taggedValues = stereotypeApplications.mapFixed[it.getFeatureValues(featureName)].flatten().mapFixed[tagType.cast(it)]
		return taggedValues
	}
	
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
