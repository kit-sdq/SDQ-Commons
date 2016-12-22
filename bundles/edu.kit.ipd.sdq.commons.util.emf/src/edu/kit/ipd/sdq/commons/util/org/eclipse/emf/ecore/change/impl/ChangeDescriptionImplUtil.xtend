package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change.impl

import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.change.ChangeKind
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl
import org.eclipse.emf.ecore.resource.Resource

import static extension edu.kit.ipd.sdq.commons.util.java.lang.ObjectUtil.*
import org.eclipse.emf.ecore.change.ListChange

/**
 * A utility class providing extension methods to hide details of backward to forward change description conversion
 *
 */
class ChangeDescriptionImplUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns a map from objects to their container and the containment reference used for it
	 */
	def static Map<EObject, Pair<EObject, EReference>> getContainmentsBeforeReversion(ChangeDescriptionImpl changeDescription) {
		return BreakEncapsulationOfChangeDescriptionImplUtil.getContainmentsBeforeReversion(changeDescription)			
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
		 * Returns a map from objects to their container and the containment reference used for it.
		 */
		static def Map<EObject, Pair<EObject, EReference>> getContainmentsBeforeReversion(ChangeDescriptionImpl changeDescription) {
			val containmentBeforeReversion = newHashMap();
			// We have to invoke the protected method changeDescription.getOldContainmentInformation() using reflection
			// in order to avoid a VerifyError due to "Bad access to protected data", which would
			// occur if we move this class to the same package as ChangeDescriptionImpl
			val resultMap = changeDescription.invokeDeclaredMethodWithoutParameters("getOldContainmentInformation",HashMap)
			val Map<EObject, OldContainmentInformation> oldContainmentUsingProtectedInnerClass =  resultMap as Map<EObject, OldContainmentInformation>
			for(entry : oldContainmentUsingProtectedInnerClass.entrySet) {
				val eObject = entry.key
//				val oldContainmentInformation = entry.value
//				val container = oldContainmentInformation.container
//				val containmentReference = oldContainmentInformation.containmentFeature
// FIXME MK remove whole old containment stuff if it is not needed?
				val container = eObject.eContainer()
				val containmentReference = eObject.eContainmentFeature()
				containmentBeforeReversion.put(eObject, new Pair(container, containmentReference))
			}
			return containmentBeforeReversion
		}
	}
	
	/**
	 * Returns a map from root objects to their resource.
	 */	
	def static Map<EObject, Resource> getResourcesBeforeReversion(ChangeDescriptionImpl changeDescription) {
		val resourceBeforeReversion = newHashMap()
		for (resourceChange : changeDescription?.resourceChanges) {
			for (listChange : resourceChange.listChanges) {
				if (isRemoveInForwardDirection(listChange)) {
					val removedRootElements = listChange.referenceValues
					for (removedRoot : removedRootElements) {
						val resourceAfterChange = removedRoot.eResource
						resourceBeforeReversion.put(removedRoot, resourceAfterChange)
					}
				}
			}
		}
		return resourceBeforeReversion
	}

	def private static boolean isRemoveInForwardDirection(ListChange listChange) {
		return listChange.kind.value == ChangeKind.ADD
	}
}
