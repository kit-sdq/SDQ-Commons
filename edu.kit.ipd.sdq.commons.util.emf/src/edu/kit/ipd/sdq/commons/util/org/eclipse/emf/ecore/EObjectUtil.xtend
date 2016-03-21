package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature

/**
 * A utility class providing extension methods for EObjects
 * 
 */
class EObjectUtil {
	 /** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	// FIXME MK replace calls to EcoreBridge.getFeatureValuesIfManyTyped
	/**
	 * Returns the list of values for the given feature of the given eObject if it is multi-valued and <code>null</code> otherwise.
	 */
	def static List<? extends EObject> getFeatureValues(EObject eObject, EStructuralFeature feature) {
		val newValue = eObject?.eGet(feature)
		if (newValue == null || !feature.many) {
			return null
		} else {
			if (newValue instanceof List<?>) {
				return newValue as List<? extends EObject>
			} else {
				throw new IllegalStateException("The value '" + newValue + "' for the multi-valued feature '" + feature + "' of the EObject '" + eObject + "' has to be a list!")
			}
		}
	}
	
	// FIXME MK replace calls to EcoreBridge.getFeatureValueIfNotManyTyped
	/**
	 * Returns the single value for the given feature of the given eObject if it is not multi-valued and <code>null</code> otherwise.
	 */
	def static Object getFeatureValue(EObject eObject, EStructuralFeature feature) {
		val newValue = eObject?.eGet(feature)
		if (newValue == null || feature.many) {
			return null
		} else {
			if (!(newValue instanceof List<?>)) {
				return newValue
			} else {
				throw new IllegalStateException("The value '" + newValue + "' for the not multi-valued feature '" + feature + "' of the EObject '" + eObject + "' has to be a list!")
			}
		}
	}
}
				