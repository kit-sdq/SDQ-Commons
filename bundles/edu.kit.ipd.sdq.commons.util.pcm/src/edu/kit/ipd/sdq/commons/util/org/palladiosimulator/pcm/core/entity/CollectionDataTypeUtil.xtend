package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity

import java.util.ArrayList
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for CollectionDataTypes
 */
@Utility
class CollectionDataTypeUtil {
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