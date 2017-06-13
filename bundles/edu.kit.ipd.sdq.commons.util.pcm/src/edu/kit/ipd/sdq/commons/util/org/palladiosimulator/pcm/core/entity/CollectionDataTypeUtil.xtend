package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity

import java.util.ArrayList
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.PrimitiveDataType

/**
 * A utility class providing extension methods for CollectionDataTypes
 */
class CollectionDataTypeUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def Iterable<DataType> getInnerTypes(Iterable<CollectionDataType> types) {
		val innerTypes = new ArrayList<DataType>
		for (type : types) {
			innerTypes.add(type.innerType)
		}
		return innerTypes
	}
	
	static def DataType getInnerType(CollectionDataType type) {
		val innerType = type.innerType_CollectionDataType
		switch (innerType) {
			CollectionDataType : return innerType.innerType
			CompositeDataType,
			PrimitiveDataType : return innerType
			default : return null
		}
	}
}