package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository

import org.palladiosimulator.pcm.repository.Parameter
import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for parameters
 */
@Utility
class ParameterUtil {
	/**
	 * Sets the parameter name of the given {@link Parameter}.
	 * In addition to the <code>parameterName</code> of the {@link Parameter}, it
	 * sets the <code>entityName</code> if that property is present.
	 * 
	 * @param parameter -
	 * 			to {@link Parameter} to set the name of. May not be <code>null</code>
	 * @param name -
	 * 			the new name
	 * 
	 * @throws IllegalArgumentException if the given {@link Parameter} is <code>null</code>.
	 */
	static def void setName(Parameter parameter, String name) {
		if (parameter === null) {
			throw new IllegalArgumentException("Parameter must not be null");
		}
		// Set entity name as well if existing
		if (parameter.eClass.EAllAttributes.exists[name=="entityName"]) {
			parameter.eSet(parameter.eClass.EAllAttributes.filter[name=="entityName"].claimOne, name);
		}
		parameter.parameterName = name;
	}
}