/*
 * We have to declare this class in the original package in order to have access to the protected method getOldContainmentInformation()
 */
package org.eclipse.emf.ecore.change.impl

import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import java.util.HashMap

/**
 * 	Breaks the encapsulation of {@link ChangeDescriptionImpl} to obtain access to the protected
 *  method {@link ChangeDescriptionImpl#getOldContainmentInformation getOldContainmentInformation} 
 *  and the protected nested class {@link ChangeDescriptionImpl.OldContainmentInformation OldContainmentInformation}.
 */
class BreakEncapsulationOfChangeDescriptionImplUtil extends ChangeDescriptionImpl {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns a map from objects to their old container and the containment reference used for it
	 */
	static def Map<EObject, Pair<EObject, EReference>> getContainmentBeforeReversion(ChangeDescriptionImpl changeDescription) {
		val containmentBeforeReversion = new HashMap<EObject, Pair<EObject, EReference>>();
		val resultMap = changeDescription.getOldContainmentInformation()
		val Map<EObject, OldContainmentInformation> oldContainmentUsingProtectedInnerClass =  resultMap as Map<EObject, OldContainmentInformation>
		for(entry : oldContainmentUsingProtectedInnerClass.entrySet) {
			val oldContainmentInformation = entry.value
			val container = oldContainmentInformation.container
			val containmentReference = oldContainmentInformation.containmentFeature
			containmentBeforeReversion.put(entry.key, new Pair(container, containmentReference))
		}
		return containmentBeforeReversion
	}
}