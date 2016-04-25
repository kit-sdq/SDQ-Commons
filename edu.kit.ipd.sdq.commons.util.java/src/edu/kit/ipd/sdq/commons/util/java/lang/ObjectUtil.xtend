package edu.kit.ipd.sdq.commons.util.java.lang

/**
 * A utility class providing extension methods for Objects
 * 
 */
class ObjectUtil {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	    
    def static <T> T invokeDeclaredMethodWithoutParameters(Object object, String methodName, Class<T> returnType) {
    	val classWithMethod = object.getClass()
    	var T castedResult
    	try {
    		val declaredMethod = classWithMethod.getDeclaredMethod(methodName)
    		declaredMethod.setAccessible(true)
			val result = declaredMethod.invoke(object)
			castedResult = returnType.cast(result)
		} catch (Exception e) {
			// soften
			throw new RuntimeException("Could not invoke method '" + methodName + "' without parameters on '" + object + "'!", e)
		}
    	return castedResult
    }
}