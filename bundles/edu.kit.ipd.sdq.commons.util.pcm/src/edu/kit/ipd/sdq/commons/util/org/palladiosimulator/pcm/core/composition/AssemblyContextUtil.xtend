package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.composition

import com.google.common.collect.Iterables
import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.palladiosimulator.pcm.core.composition.AssemblyConnector
import org.palladiosimulator.pcm.core.composition.AssemblyContext
import org.palladiosimulator.pcm.core.composition.Connector
import org.palladiosimulator.pcm.core.composition.ProvidedDelegationConnector
import org.palladiosimulator.pcm.core.composition.RequiredDelegationConnector
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*
import java.util.List
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationRequiredRole
import org.palladiosimulator.pcm.core.composition.DelegationConnector
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for assembly contexts
 * 
 */
@Utility
class AssemblyContextUtil {
	static final def List<OperationInterface> getProvidedOperationInterfaces(AssemblyContext assemblyContext) {
		return getOperationInterfaces(assemblyContext, true)
	}
	
	static final def List<OperationInterface> getRequiredOperationInterfaces(AssemblyContext assemblyContext) {
		return getOperationInterfaces(assemblyContext, false)
	}
	
	static final def List<OperationInterface> getOperationInterfaces(AssemblyContext assemblyContext, boolean providedNotRequired) {
		val component = assemblyContext.encapsulatedComponent__AssemblyContext
		if (providedNotRequired) {
			return component?.providedRoles_InterfaceProvidingEntity?.filter(typeof(OperationProvidedRole)).mapFixed[it.providedInterface__OperationProvidedRole]
		} else {
			return component?.requiredRoles_InterfaceRequiringEntity?.filter(typeof(OperationRequiredRole)).mapFixed[it.requiredInterface__OperationRequiredRole]
		}
	}
	
	static final def Iterable<Connector> getAssemblyOrDelegationConnectorsAtProvidedInterfaces(AssemblyContext assemblyContext) {
		return getAssemblyOrDelegationConnectors(assemblyContext, true)
	}
	
	static final def Iterable<Connector> getAssemblyOrDelegationConnectorsAtRequiredInterfaces(AssemblyContext assemblyContext) {
		return getAssemblyOrDelegationConnectors(assemblyContext, false)
	}
	
	static final def Iterable<Connector> getAssemblyOrDelegationConnectors(AssemblyContext assemblyContext, boolean providedNotRequired) {
		return Iterables.concat(getAssemblyConnectors(assemblyContext, providedNotRequired),getDelegationConnectors(assemblyContext, providedNotRequired))
	}
	
	static final def Iterable<AssemblyConnector> getAssemblyConnectorsAtProvidedInterfaces(AssemblyContext assemblyContext) {
		return getAssemblyConnectors(assemblyContext, true)
	}
	
	static final def Iterable<AssemblyConnector> getAssemblyConnectorsAtRequiredInterfaces(AssemblyContext assemblyContext) {
		return getAssemblyConnectors(assemblyContext, false)
	}
	
	static final def Iterable<AssemblyConnector> getAssemblyConnectors(AssemblyContext assemblyContext, boolean providedNotRequired) {
		return getConnectorsOfTypeThatFulfillPredicate(assemblyContext, AssemblyConnector, [AssemblyConnector ac | return (if (providedNotRequired) ac.providingAssemblyContext_AssemblyConnector else ac.requiringAssemblyContext_AssemblyConnector) == assemblyContext])
	}
	
	static final def Iterable<ProvidedDelegationConnector> getDelegationConnectorsAtProvidedInterfaces(AssemblyContext assemblyContext) {
		return getDelegationConnectors(assemblyContext, ProvidedDelegationConnector)
	}
	
	static final def Iterable<RequiredDelegationConnector> getDelegationConnectorsAtRequiredInterfaces(AssemblyContext assemblyContext) {
		return getDelegationConnectors(assemblyContext, RequiredDelegationConnector)
	}
	
	static final def Iterable<? extends DelegationConnector> getDelegationConnectors(AssemblyContext assemblyContext, boolean providedNotRequired) {
		val connectorType = if (providedNotRequired) ProvidedDelegationConnector else RequiredDelegationConnector
		return getDelegationConnectors(assemblyContext, connectorType)
	}
	
	static final def <T extends DelegationConnector> Iterable<T> getDelegationConnectors(AssemblyContext assemblyContext, Class<T> connectorType) {
		return getConnectorsOfTypeThatFulfillPredicate(assemblyContext, connectorType, [T rdc | return (if (rdc instanceof ProvidedDelegationConnector) rdc.assemblyContext_ProvidedDelegationConnector else if (rdc instanceof RequiredDelegationConnector) rdc.assemblyContext_RequiredDelegationConnector else null) == assemblyContext])
	}
	
	private static final def <T extends Connector> Iterable<T> getConnectorsOfTypeThatFulfillPredicate(AssemblyContext assemblyContext, Class<T> connectorType, Function1<? super T, Boolean> conncetorPredicate) {
		val allConnectors = assemblyContext?.parentStructure__AssemblyContext?.connectors__ComposedStructure
		return Iterables.filter(allConnectors, connectorType).filter[conncetorPredicate.apply(it)]
	}
}