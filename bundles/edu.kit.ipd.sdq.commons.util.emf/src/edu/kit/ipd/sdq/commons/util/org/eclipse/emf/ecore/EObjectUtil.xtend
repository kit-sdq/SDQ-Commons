package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore

import java.util.List
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EReference
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for EObjects
 */
@Utility
class EObjectUtil {
	/**
	 * Returns the list of values for the feature with the given name of the given eObject if it is multi-valued and <code>null</code> otherwise.
	 */
	def static List<?> getFeatureValues(EObject eObject, String featureName) {
		val feature = eObject.eClass.getEStructuralFeature(featureName)
		return getFeatureValues(eObject, feature)
	}
	
	// FIXME MK replace calls to EcoreBridge.getFeatureValuesIfManyTyped with calls to this method
	/**
	 * Returns the list of values for the given feature of the given eObject if it is multi-valued and <code>null</code> otherwise.
	 */
	def static List<?> getFeatureValues(EObject eObject, EStructuralFeature feature) {
		val newValue = eObject?.eGet(feature)
		if (newValue === null || !feature.many) {
			return null
		} else {
			if (newValue instanceof List<?>) {
				return newValue
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
		if (newValue === null || feature.many) {
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
		if (feature.many && value !== null) {
			return value as EList<?>
		} else if (value === null) {
			return new BasicEList()
		} else {
			return new BasicEList(#[value])
		}
	}
	
    /**
     * Returns an iterable for iterating over all direct and indirect contents of the given EObject.
     *
     * @param eObject
     *            container EObject
     * @return a direct and indirect content iterating iterable
     *
     * @see org.eclipse.emf.ecore.EObject#eAllContents() EObject.eAllContents()
     */
    def static Iterable<EObject> getAllContents(EObject eObject) {
        return eObject?.eAllContents()?.toIterable()
    }
    
	/**
	 * Returns an iterable for iterating over all direct and indirect contents of the given Resource.
	 *
	 * @param resource
	 *            container Resource
	 * @return a direct and indirect content iterating iterable
	 *
	 * @see org.eclipse.emf.ecore.Resource#eAllContents() Resource.eAllContents()
	 * @deprecated {@link edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource.ResourceUtil#getAllContentsIterable(Resource)}
     */
	@Deprecated
	def static Iterable<EObject> getAllContents(Resource resource) {
	    return resource.getAllContents().toIterable()
	}
	
	/** 
	 * Returns the {@link EAttribute} of the {@link EClass} of the given {@link EObject} with the given name.
	 * 
	 * @param eObject the {@link EObject} to get the attribute definition from
	 * @param attributeName the name of the attribute the find
	 * 
	 * @return the {@link EAttribute} of the objects {@link EClass} with the given name 
	 */
	def static EAttribute getAttributeByName(EObject eObject, String attributeName) {
		return eObject.eClass.getEAllAttributes.filter[attribute|attribute.name.equals(attributeName)].iterator.next
	}

	/** 
	 * Returns the {@link EReference} of the {@link EClass} of the given {@link EObject} with the given name.
	 * 
	 * @param eObject the {@link EObject} to get the reference definition from
	 * @param referenceName the name of the reference the find
	 * 
	 * @return the {@link EReference} of the objects {@link EClass} with the given name 
	 */
	def static EReference getReferenceByName(EObject eObject, String referenceName) {
		return eObject.eClass.getEAllReferences.filter[reference|reference.name.equals(referenceName)].iterator.next
	}
}
				