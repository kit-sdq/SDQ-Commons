package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import java.util.regex.Pattern
import java.io.File
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.resources.IContainer

/**
 * A utility class providing extension methods for IProjects
 * 
 */
class IProjectUtil {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}

	def static IFolder createFolderInProjectIfNecessary(IProject project, String folderName) {
		val pattern = Pattern.compile(Pattern.quote(File.separator))
		val folderNames = pattern.split(folderName)
		var IContainer currentContainer = project
		var IFolder folder = null
		for (folderNamePart : folderNames) {
			folder = currentContainer.getFolder(new Path(folderNamePart))
			if (!folder.exists()) {
				try {
					folder.create(true, true, new NullProgressMonitor())
				} catch (CoreException e) {
					// soften
					throw new RuntimeException(e);
				}
			}
			currentContainer = folder;
		}
		return folder;
	}
	
}