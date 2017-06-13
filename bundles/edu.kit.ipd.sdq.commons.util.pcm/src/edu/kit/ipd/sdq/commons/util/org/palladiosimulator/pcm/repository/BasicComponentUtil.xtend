package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository

import java.util.HashSet
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.OperationInterface

import static edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository.OperationInterfaceUtil.*

/**
 * A utility class providing extension methods for roles
 * 
 */
class BasicComponentUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {}	
	
	static def Iterable<OperationInterface> getAllInheritedOperationInterfaces(BasicComponent bc) {
		val inheritedIfaces = new HashSet<OperationInterface>
		inheritedIfaces.addAll(bc.directInheritedOperationInterfaces)
		inheritedIfaces.addAll(bc.indirectInheritedOperationInterfaces)
		return inheritedIfaces
	}
	
	static def Iterable<OperationInterface> getDirectInheritedOperationInterfaces(BasicComponent bc) {
		return getProvidedInterfaces(bc).map[it.parentInterfaces__Interface].flatten.filter(OperationInterface)
	}
	
	static def Iterable<OperationInterface> getIndirectInheritedOperationInterfaces(BasicComponent bc) {
		return getProvidedInterfaces(bc).map[it.parentInterfaces__Interface].flatten.filter(OperationInterface).map[it.allInheritedOperationInterfaces].flatten
	}
	
}