package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.runtime.CoreException

class IWorkspaceUtil {
	/**
	 * Turns off the automatic build feature of the given workspace if it is currently switched on and
	 * returns {@code true} when this was the case.
	 * 
	 * @param workspace -
	 * 		the {@link IWorksace} to turn automatic build off for
	 * @return whether automatic build was turned on before
	 * @throws CoreException
	 * 		if the feature could not be set
	 */
	static def boolean turnOffAutoBuildIfOn(IWorkspace workspace) throws CoreException {
		val description = workspace.getDescription();
		if (description.isAutoBuilding()) {
			description.setAutoBuilding(false);
			workspace.setDescription(description);
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Turns on the automatic build feature for the given workspace.
	 * 
	 * @param workspace -
	 * 		the {@link IWorkspace} to turn automatic build on for
	 * @throws CoreException
	 * 		if the feature could not be set
	 */
	static def void turnOnAutoBuild(IWorkspace workspace) throws CoreException {
		val description = workspace.getDescription();
		if (!description.isAutoBuilding()) {
			description.setAutoBuilding(true);
			workspace.setDescription(description);
		}
	}

}
