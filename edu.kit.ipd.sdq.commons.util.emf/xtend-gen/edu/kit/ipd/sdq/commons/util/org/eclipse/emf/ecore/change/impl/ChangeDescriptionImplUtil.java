package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change.impl;

import java.util.Map;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.change.impl.BreakEncapsulationOfChangeDescriptionImplUtil;
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl;
import org.eclipse.xtext.xbase.lib.Pair;

/**
 * A utility class providing extension methods to hide details of backward to forward change description conversion
 */
@SuppressWarnings("all")
public class ChangeDescriptionImplUtil {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private ChangeDescriptionImplUtil() {
  }
  
  /**
   * Returns a map from objects to their old container and the containment reference used for it
   */
  public static Map<EObject, Pair<EObject, EReference>> getContainmentBeforeReversion(final ChangeDescriptionImpl changeDescription) {
    return BreakEncapsulationOfChangeDescriptionImplUtil.getContainmentBeforeReversion(changeDescription);
  }
}
