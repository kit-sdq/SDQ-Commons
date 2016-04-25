package edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.change.impl;

import org.eclipse.emf.ecore.change.ChangeDescription;
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl;

/**
 * A utility class providing extension methods to hide details of change descriptions
 */
@SuppressWarnings("all")
public class ChangeDescriptionUtil {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private ChangeDescriptionUtil() {
  }
  
  public static ChangeDescriptionImpl asImpl(final ChangeDescription changeDescription) {
    if ((changeDescription instanceof ChangeDescriptionImpl)) {
      return ((ChangeDescriptionImpl) changeDescription);
    } else {
      throw new RuntimeException((("The EMF change description " + changeDescription) + " is not an instance of ChangeDescriptionImpl!"));
    }
  }
}
