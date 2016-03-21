package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore;

import com.google.common.base.Objects;
import java.util.List;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;

/**
 * A utility class providing extension methods for EObjects
 */
@SuppressWarnings("all")
public class EObjectUtil {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private EObjectUtil() {
  }
  
  /**
   * Returns the list of values for the given feature of the given eObject if it is multi-valued and <code>null</code> otherwise.
   */
  public static List<? extends EObject> getFeatureValues(final EObject eObject, final EStructuralFeature feature) {
    Object _eGet = null;
    if (eObject!=null) {
      _eGet=eObject.eGet(feature);
    }
    final Object newValue = _eGet;
    boolean _or = false;
    boolean _equals = Objects.equal(newValue, null);
    if (_equals) {
      _or = true;
    } else {
      boolean _isMany = feature.isMany();
      boolean _not = (!_isMany);
      _or = _not;
    }
    if (_or) {
      return null;
    } else {
      if ((newValue instanceof List<?>)) {
        return ((List<? extends EObject>) newValue);
      } else {
        throw new IllegalStateException((((((("The value \'" + newValue) + "\' for the multi-valued feature \'") + feature) + "\' of the EObject \'") + eObject) + "\' has to be a list!"));
      }
    }
  }
  
  /**
   * Returns the single value for the given feature of the given eObject if it is not multi-valued and <code>null</code> otherwise.
   */
  public static Object getFeatureValue(final EObject eObject, final EStructuralFeature feature) {
    Object _eGet = null;
    if (eObject!=null) {
      _eGet=eObject.eGet(feature);
    }
    final Object newValue = _eGet;
    boolean _or = false;
    boolean _equals = Objects.equal(newValue, null);
    if (_equals) {
      _or = true;
    } else {
      boolean _isMany = feature.isMany();
      _or = _isMany;
    }
    if (_or) {
      return null;
    } else {
      if ((!(newValue instanceof List<?>))) {
        return newValue;
      } else {
        throw new IllegalStateException((((((("The value \'" + newValue) + "\' for the not multi-valued feature \'") + feature) + "\' of the EObject \'") + eObject) + "\' has to be a list!"));
      }
    }
  }
}
