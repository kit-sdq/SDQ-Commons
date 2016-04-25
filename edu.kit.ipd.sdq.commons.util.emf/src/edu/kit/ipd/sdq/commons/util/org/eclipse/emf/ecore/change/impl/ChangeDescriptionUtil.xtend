package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change.impl

import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl
import org.eclipse.emf.ecore.change.ChangeDescription

/**
 * A utility class providing extension methods to hide details of change descriptions
 *
 */
class ChangeDescriptionUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	def static ChangeDescriptionImpl asImpl(ChangeDescription changeDescription) {
		if (changeDescription instanceof ChangeDescriptionImpl) {
			return changeDescription as ChangeDescriptionImpl
		} else {
			throw new RuntimeException("The EMF change description " + changeDescription + " is not an instance of ChangeDescriptionImpl!")
		}
	}
}