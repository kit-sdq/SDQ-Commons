package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository

import java.util.ArrayList
import java.util.HashSet
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationSignature
import edu.kit.kastel.scbs.confidentiality.repository.ParametersAndDataPair

import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.mdsdprofiles.api.StereotypeAPIUtil.*

/**
 * A utility class providing extension methods for roles
 * 
 */
class OperationInterfaceUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {}
		
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
	
	static def Iterable<ParametersAndDataPair> getAllParamatersAndDataPairs(OperationInterface iface) {		
		val result = new ArrayList<ParametersAndDataPair>
		result.addAll(iface.parametersAndDataPairs)
		result.addAll(iface.allSignatureParametersAndDataPairs)
		return result
	}
	
	static def Iterable<ParametersAndDataPair> getParametersAndDataPairs(OperationInterface iface) {
		iface.getTaggedValues("InformationFlow", "parametersAndDataPairs", ParametersAndDataPair)
	}
	
	static def Iterable<ParametersAndDataPair> getAllParametersAndDataPairsAppliedToSignature(OperationInterface iface, OperationSignature operationSignature) {
		val result = new ArrayList<ParametersAndDataPair>
		result.addAll(iface.parametersAndDataPairs)
		result.addAll(operationSignature.parametersAndDataPairs)
		return result
	}
	
	static def Iterable<ParametersAndDataPair> getAllSignatureParametersAndDataPairs(OperationInterface iface) {
		iface.signatures__OperationInterface.map[it.parametersAndDataPairs].flatten
	}
	
	static def Iterable<ParametersAndDataPair> getParametersAndDataPairs(OperationSignature operationSignature) {
		operationSignature.getTaggedValues("InformationFlow", "parametersAndDataPairs", ParametersAndDataPair)
	}
	
}