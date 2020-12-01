package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity

import org.palladiosimulator.pcm.core.entity.InterfaceRequiringEntity
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationRequiredRole
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for InterfaceRequiringEntitys
 */
@Utility
class InterfaceRequiringEntityUtil {
	static def Iterable<OperationInterface> getRequiredInterfaces(InterfaceRequiringEntity ire) {
		return ire.requiredRoles_InterfaceRequiringEntity.filter(OperationRequiredRole).map[it.requiredInterface__OperationRequiredRole]
	}
}