/**
 * We have to declare this class in the original package in order to have access to the protected method getOldContainmentInformation()
 */
package org.eclipse.emf.ecore.change.impl;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.change.impl.ChangeDescriptionImpl;
import org.eclipse.xtext.xbase.lib.Pair;

/**
 * Breaks the encapsulation of {@link ChangeDescriptionImpl} to obtain access to the protected
 *  method {@link ChangeDescriptionImpl#getOldContainmentInformation getOldContainmentInformation}
 *  and the protected nested class {@link ChangeDescriptionImpl.OldContainmentInformation OldContainmentInformation}.
 */
@SuppressWarnings("all")
public class BreakEncapsulationOfChangeDescriptionImplUtil extends ChangeDescriptionImpl {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private BreakEncapsulationOfChangeDescriptionImplUtil() {
  }
  
  /**
   * Returns a map from objects to their old container and the containment reference used for it
   */
  public static Map<EObject, Pair<EObject, EReference>> getContainmentBeforeReversion(final ChangeDescriptionImpl changeDescription) {
    final HashMap<EObject, Pair<EObject, EReference>> containmentBeforeReversion = new HashMap<EObject, Pair<EObject, EReference>>();
    final Map<EObject, ChangeDescriptionImpl.OldContainmentInformation> resultMap = changeDescription.getOldContainmentInformation();
    final Map<EObject, ChangeDescriptionImpl.OldContainmentInformation> oldContainmentUsingProtectedInnerClass = ((Map<EObject, ChangeDescriptionImpl.OldContainmentInformation>) resultMap);
    Set<Map.Entry<EObject, ChangeDescriptionImpl.OldContainmentInformation>> _entrySet = oldContainmentUsingProtectedInnerClass.entrySet();
    for (final Map.Entry<EObject, ChangeDescriptionImpl.OldContainmentInformation> entry : _entrySet) {
      {
        final ChangeDescriptionImpl.OldContainmentInformation oldContainmentInformation = entry.getValue();
        final EObject container = oldContainmentInformation.container;
        final EReference containmentReference = oldContainmentInformation.containmentFeature;
        EObject _key = entry.getKey();
        Pair<EObject, EReference> _pair = new Pair<EObject, EReference>(container, containmentReference);
        containmentBeforeReversion.put(_key, _pair);
      }
    }
    return containmentBeforeReversion;
  }
}
