package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity

import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.repository.OperationProvidedRole

/**
 * A utility class providing extension methods for InterfaceProvidingEntitys
 */
class InterfaceProvidingEntityUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}	
	
	static def Iterable<OperationInterface> getProvidedInterfaces(InterfaceProvidingEntity ipe) {
		return ipe.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole]
	}
	
}