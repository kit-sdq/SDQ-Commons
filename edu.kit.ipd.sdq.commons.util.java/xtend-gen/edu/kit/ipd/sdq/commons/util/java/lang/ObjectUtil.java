package edu.kit.ipd.sdq.commons.util.java.lang;

import java.lang.reflect.Method;
import org.eclipse.xtext.xbase.lib.Exceptions;

/**
 * A utility class providing extension methods for Objects
 */
@SuppressWarnings("all")
public class ObjectUtil {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private ObjectUtil() {
  }
  
  public static <T extends Object> T invokeDeclaredMethodWithoutParameters(final Object object, final String methodName, final Class<T> returnType) {
    final Class<?> classWithMethod = object.getClass();
    T castedResult = null;
    try {
      final Method declaredMethod = classWithMethod.getDeclaredMethod(methodName);
      declaredMethod.setAccessible(true);
      final Object result = declaredMethod.invoke(object);
      T _cast = returnType.cast(result);
      castedResult = _cast;
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception e = (Exception)_t;
        throw new RuntimeException((((("Could not invoke method \'" + methodName) + "\' without parameters on \'") + object) + "\'!"), e);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return castedResult;
  }
}
