package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository

import org.palladiosimulator.pcm.repository.Role
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationRequiredRole
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for roles
 */
@Utility
class RoleUtil {
	static def OperationInterface getOperationInterface(Role role, boolean providedNotRequired) {
		val interface = switch role {
			OperationProvidedRole : if (providedNotRequired) role.providedInterface__OperationProvidedRole else throw new RuntimeException("Cannot get required interface for OperationProvidedRole '" + role + "'!")
			OperationRequiredRole : if (!providedNotRequired) role.requiredInterface__OperationRequiredRole else throw new RuntimeException("Cannot get provided interface for OperationRequiredRole '" + role + "'!")
		}
		return interface
	}
}