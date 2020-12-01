package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository

import java.util.HashSet
import org.palladiosimulator.pcm.repository.OperationInterface
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for operation interfaces
 */
@Utility
class OperationInterfaceUtil {
	static def Iterable<OperationInterface> getAllInheritedOperationInterfaces(OperationInterface iface) {
		val inheritedIfaces = new HashSet<OperationInterface>
		inheritedIfaces.addAll(iface.directInheritedOperationInterfaces)
		inheritedIfaces.addAll(iface.indirectInheritedOperationInterfaces)
		return inheritedIfaces
	}

	static def Iterable<OperationInterface> getDirectInheritedOperationInterfaces(OperationInterface iface) {
		return iface.parentInterfaces__Interface.toSet.filter(OperationInterface)
	}
	
	static def Iterable<OperationInterface> getIndirectInheritedOperationInterfaces(OperationInterface iface) {	
		return iface.parentInterfaces__Interface.map[it.parentInterfaces__Interface].filter(OperationInterface)
	}
}