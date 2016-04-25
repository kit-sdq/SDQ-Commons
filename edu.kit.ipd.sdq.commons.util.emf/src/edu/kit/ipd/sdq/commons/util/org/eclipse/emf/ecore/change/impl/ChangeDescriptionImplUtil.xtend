package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change.impl

import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.change.impl.BreakEncapsulationOfChangeDescriptionImplUtil
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl

/**
 * A utility class providing extension methods to hide details of backward to forward change description conversion
 *
 */
class ChangeDescriptionImplUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns a map from objects to their old container and the containment reference used for it
	 */
	def static Map<EObject, Pair<EObject, EReference>> getContainmentBeforeReversion(ChangeDescriptionImpl changeDescription) {
		return BreakEncapsulationOfChangeDescriptionImplUtil.getContainmentBeforeReversion(changeDescription)			
	}
}
