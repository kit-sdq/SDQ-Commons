package edu.kit.ipd.sdq.commons.util.org.palladiosimulator.mdsdprofiles.api;

import com.google.common.collect.Iterables;
import edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.EObjectUtil;
import edu.kit.ipd.sdq.vitruvius.framework.util.bridges.CollectionBridge;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.modelversioning.emfprofileapplication.StereotypeApplication;
import org.palladiosimulator.mdsdprofiles.api.StereotypeAPI;

/**
 * A utility class providing extension methods for stereotypable EObjects
 */
@SuppressWarnings("all")
public class StereotypeAPIUtil {
  /**
   * Utility classes should not have a public or default constructor.
   */
  private StereotypeAPIUtil() {
  }
  
  public static <T extends Object> List<T> getTaggedValues(final EObject eObject, final String stereotypeName, final String featureName, final Class<T> clazz) {
    final EList<StereotypeApplication> stereotypeApplications = StereotypeAPI.getStereotypeApplications(eObject, stereotypeName);
    final Function1<StereotypeApplication, List<?>> _function = (StereotypeApplication it) -> {
      return EObjectUtil.getFeatureValues(it, featureName);
    };
    List<List<?>> _mapFixed = CollectionBridge.<StereotypeApplication, List<?>>mapFixed(stereotypeApplications, _function);
    Iterable<Object> _flatten = Iterables.<Object>concat(_mapFixed);
    final Function1<Object, T> _function_1 = (Object it) -> {
      return clazz.cast(it);
    };
    final List<T> taggedValues = CollectionBridge.<Object, T>mapFixed(_flatten, _function_1);
    return taggedValues;
  }
}
