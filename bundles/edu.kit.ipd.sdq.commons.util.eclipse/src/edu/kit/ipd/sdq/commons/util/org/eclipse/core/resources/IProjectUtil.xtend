package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import java.util.regex.Pattern
import java.io.File
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.resources.IContainer
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.jdt.core.JavaCore
import org.eclipse.jdt.launching.JavaRuntime
import static com.google.common.base.Preconditions.checkState
import java.nio.file.Path
import edu.kit.ipd.sdq.activextendannotations.Utility
import org.eclipse.jdt.core.IJavaProject

/**
 * A utility class providing extension methods for IProjects
 */
@Utility
class IProjectUtil {
	public static val JAVA_SOURCE_FOLDER = Path.of('src')
	public static val JAVA_BIN_FOLDER = Path.of('bin')

	def static IFolder createFolderInProjectIfNecessary(IProject project, String folderName) {
		val pattern = Pattern.compile(Pattern.quote(File.separator))
		val folderNames = pattern.split(folderName)
		var IContainer currentContainer = project
		var IFolder folder = null
		for (folderNamePart : folderNames) {
			folder = currentContainer.getFolder(new org.eclipse.core.runtime.Path(folderNamePart))
			if (!folder.exists()) {
				try {
					folder.create(true, true, new NullProgressMonitor())
				} catch (CoreException e) {
					// soften
					throw new RuntimeException(e)
				}
			}
			currentContainer = folder
		}
		return folder
	}

	/**
	 * Returns the project with the given name in the current Eclipse workspace.
	 * @param projectName
	 * 		- the name of the project to retrieve 
	 * @returns the project with the given name in the workspace
	 */
	def static IProject getWorkspaceProject(String projectName) {
		return ResourcesPlugin.getWorkspace().getRoot().getProject(projectName)
	}

	def static createProjectAt(String projectName, Path projectLocation) {
		getWorkspaceProject(projectName) => [
			checkState(!exists, '''The project «projectName» already exists!''')
			create(workspace.newProjectDescription(projectName) => [
				location = new org.eclipse.core.runtime.Path(projectLocation.toString)
			], null)
		]
	}

	/**
	 * Configures the given {@link IProject} to be a java project, i.e. adds the Java nature
	 * and a {@link #JAVA_SOURCE_FOLDER} to the project and registers the Java standard library.
	 * <br>
	 * To create the expected {@link IProject}, {@link #getWorkspaceProject IProjectUtil.getWorkspaceProject} can be used.
	 * 
	 * @param project - the {@link IProject} to initialize as a Java project
	 * @throws IllegalStateException if the project already exists
	 * @throws CoreException if configuring the project fails
	 */
	def static IJavaProject configureAsJavaProject(IProject project) {
		// copied from:
		// https://sdqweb.ipd.kit.edu/wiki/JDT_Tutorial:_Creating_Eclipse_Java_Projects_Programmatically
		project.open(new NullProgressMonitor())
		val description = project.getDescription()
		val currentNatureIds = description.natureIds
		val newNatureIds = newArrayOfSize(currentNatureIds.length + 1)
		System.arraycopy(currentNatureIds, 0, newNatureIds, 0, currentNatureIds.length)
		newNatureIds.set(currentNatureIds.length, JavaCore.NATURE_ID)
		description.setNatureIds(newNatureIds)
		project.setDescription(description, null)
		
		val javaProject = JavaCore.create(project)
		val binFolder = project.getFolder(JAVA_BIN_FOLDER.toString())
		binFolder.create(false, true, null)
		javaProject.setOutputLocation(binFolder.getFullPath(), null)
		val entries = newArrayList()
		val vmInstall = JavaRuntime.getDefaultVMInstall()
		if (null !== vmInstall) {
			val locations = JavaRuntime.getLibraryLocations(vmInstall)
			for (element : locations) {
				entries.add(JavaCore.newLibraryEntry(element.getSystemLibraryPath(), null, null))
			}
		}
		// Add libs to project class path
		javaProject.setRawClasspath(entries.toArray(newArrayOfSize(entries.size())), null)
		val sourceFolder = project.getFolder(JAVA_SOURCE_FOLDER.toString())
		sourceFolder.create(false, true, null)
		val root = javaProject.getPackageFragmentRoot(sourceFolder)
		val oldEntries = javaProject.getRawClasspath()
		val newEntries = newArrayOfSize(oldEntries.length + 1)
		java.lang.System.arraycopy(oldEntries, 0, newEntries, 0, oldEntries.length)
		newEntries.set(oldEntries.length, JavaCore.newSourceEntry(root.getPath()))
		javaProject.setRawClasspath(newEntries, null)
		return javaProject
	}

	/**
	 * Creates a Java project for the given {@link IProject}, adding the Java nature
	 * and a "src" folder to the project and registering the Java standard library.
	 * If the given project already exists, an {@link IllegalStateException} is thrown.
	 * <br>
	 * To create the expected {@link IProject}, {@link #getWorkspaceProject IProjectUtil.getWorkspaceProject} can be used.
	 * 
	 * @param project - the {@link IProject} to initialize as a Java project
	 * @returns whether the project was successfully created or not
	 * @throws IllegalStateException if the project already exists
	 */
	def static boolean createJavaProject(IProject project) {
		checkState(!project.exists, '''The project «project.name» already exists!''')
		try {
			project.create(new NullProgressMonitor())
			configureAsJavaProject(project)
		} catch (CoreException e) {
			return false
		}
		return true
	}

	/**
	 * Creates a Java project with the given name in the current workspace, adding the Java nature
	 * and a "src" folder to the project and registering the Java standard library.
	 * If the given project already exists, an {@link IllegalStateException} is thrown.
	 * 
	 * @param projectName - the name of the project to create
	 * @returns whether the project was successfully created or not
	 * @throws IllegalStateException if the project already exists
	 */
	def static boolean createJavaProject(String projectName) {
		getWorkspaceProject(projectName).createJavaProject()
	}
}
