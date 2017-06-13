package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity

import java.util.ArrayList
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum

/**
 * A utility class providing extension methods for CompositeDataTypes
 */
class CompositeDataTypeUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns a list of all inner declarations of the given data type that are not primitive.
	 * That includes inner declarations with type String as it is a reference type.
	 */
	static def Iterable<InnerDeclaration> getNonPrimitiveDeclarations(CompositeDataType dataType) {
		val nonPrimitiveFields = new ArrayList<InnerDeclaration>
		for (declaration : dataType.innerDeclaration_CompositeDataType) {
			val innerType = declaration.datatype_InnerDeclaration
			switch (innerType) {
				CollectionDataType, 
				CompositeDataType: nonPrimitiveFields.add(declaration) 
				PrimitiveDataType: if (innerType.type == PrimitiveTypeEnum::STRING) {
								   	   nonPrimitiveFields.add(declaration)
								   }
			}
		}
		return nonPrimitiveFields
	}
	
}