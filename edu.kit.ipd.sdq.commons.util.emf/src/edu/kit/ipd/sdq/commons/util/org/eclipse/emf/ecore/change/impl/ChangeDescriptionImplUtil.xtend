package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change.impl

import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl
import java.util.HashMap
import static extension edu.kit.ipd.sdq.commons.util.java.lang.ObjectUtil.*

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
	
	/**
	 * 	Breaks the encapsulation of {@link ChangeDescriptionImpl} to obtain access to the protected
	 *  method {@link ChangeDescriptionImpl#getOldContainmentInformation getOldContainmentInformation} 
	 *  and the protected nested class {@link ChangeDescriptionImpl.OldContainmentInformation OldContainmentInformation}.
	 */
	static class BreakEncapsulationOfChangeDescriptionImplUtil extends ChangeDescriptionImpl {
		/** Utility classes should not have a public or default constructor. */
		private new() {
		}
	
		/**
		 * Returns a map from objects to their old container and the containment reference used for it.
		 */
		static def Map<EObject, Pair<EObject, EReference>> getContainmentBeforeReversion(ChangeDescriptionImpl changeDescription) {
			val containmentBeforeReversion = new HashMap<EObject, Pair<EObject, EReference>>();
			// We have to invoke the protected method changeDescription.getOldContainmentInformation() using reflection
			// in order to avoid a VerifyError due to "Bad access to protected data", which would
			// occur if we move this class to the same package as ChangeDescriptionImpl
			val resultMap = changeDescription.invokeDeclaredMethodWithoutParameters("getOldContainmentInformation",HashMap)
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
}
