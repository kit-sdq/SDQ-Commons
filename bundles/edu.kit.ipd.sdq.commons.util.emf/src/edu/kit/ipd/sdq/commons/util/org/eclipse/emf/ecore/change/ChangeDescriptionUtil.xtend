package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change

import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl
import org.eclipse.emf.ecore.change.ChangeDescription
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods to hide details of change descriptions
 */
@Utility
class ChangeDescriptionUtil {
	def static ChangeDescriptionImpl asImpl(ChangeDescription changeDescription) {
		if (changeDescription instanceof ChangeDescriptionImpl) {
			return changeDescription
		} else {
			throw new RuntimeException("The EMF change description " + changeDescription + " is not an instance of ChangeDescriptionImpl!")
		}
	}
}