package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore

import java.util.List
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
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
	
	// FIXME MK replace calls to EcoreBridge.getFeatureValuesIfManyTyped with calls to this method
	/**
	 * Returns the list of values for the given feature of the given eObject if it is multi-valued and <code>null</code> otherwise.
	 */
	def static List<?> getFeatureValues(EObject eObject, EStructuralFeature feature) {
		val newValue = eObject?.eGet(feature)
		if (newValue == null || !feature.many) {
			return null
		} else {
			if (newValue instanceof List<?>) {
				return newValue as List<?>
			} else {
				throw new IllegalStateException("The value '" + newValue + "' for the multi-valued feature '" + feature + "' of the EObject '" + eObject + "' has to be a list!")
			}
		}
	}
	
	// FIXME MK replace calls to EcoreBridge.getFeatureValueIfNotManyTyped with calls to this method
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
	
	def static EList<?> getValueList(EObject eObject, EStructuralFeature feature) {
		val value = eObject.eGet(feature)
		if (feature.many && value != null) {
			return value as EList<?>
		} else if (value == null) {
			return new BasicEList()
		} else {
			return new BasicEList(#[value])
		}
	}
}
				