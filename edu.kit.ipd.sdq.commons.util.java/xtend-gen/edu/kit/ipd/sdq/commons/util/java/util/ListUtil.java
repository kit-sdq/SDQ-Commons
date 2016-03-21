package edu.kit.ipd.sdq.commons.util.java.util;

import com.google.common.base.Objects;
import java.util.List;

/**
 * A utility class providing extension methods for Lists
 */
@SuppressWarnings("all")
public class ListUtil {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private ListUtil() {
  }
  
  /**
   * Returns the element at the given index and throws an {@link java.lang.IllegalStateException} if it is not existing.
   */
  public static <T extends Object> T claimElementAt(final List<T> list, final int index) {
    T _get = null;
    if (list!=null) {
      _get=list.get(index);
    }
    final T element = _get;
    boolean _equals = Objects.equal(element, null);
    if (_equals) {
      throw new IllegalStateException((((("It was claimed that the list \'" + list) + "\' contains an element at index \'") + Integer.valueOf(index)) + "\'!"));
    } else {
      return element;
    }
  }
}
