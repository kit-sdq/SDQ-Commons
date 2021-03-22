package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import edu.kit.ipd.sdq.activextendannotations.Utility
import java.nio.file.Path
import org.eclipse.core.resources.IContainer
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.jdt.core.IClasspathAttribute
import org.eclipse.jdt.core.IJavaProject
import org.eclipse.jdt.core.JavaCore

import static com.google.common.base.Preconditions.checkState
import static org.eclipse.jdt.core.IClasspathEntry.CPE_SOURCE

import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources.IPathUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources.IResourceUtil.*
import org.eclipse.jdt.ui.PreferenceConstants
import org.eclipse.core.resources.IncrementalProjectBuilder
import org.eclipse.core.resources.ICommand
import org.eclipse.core.resources.IResource
import static com.google.common.base.Preconditions.checkArgument
import org.apache.log4j.Logger

/**
 * A utility class providing extension methods for IProjects
 */
@Utility
class IProjectUtil {
	static val LOGGER = Logger.getLogger(IProjectUtil)

	/**
	 * Relative path to the folder that will be configured as source folder for Java projects.
	 */
	public static val JAVA_SOURCE_FOLDER = Path.of('src')
	/**
	 * Relative path to the folder that will be configured as output folder for Java projects.
	 */
	public static val JAVA_BIN_FOLDER = Path.of('bin')
	/**
	 * Relative path to the folder that can optionally be configured as output folder for generated sources for Java
	 * projects.
	 */
	public static val SOURCE_GEN_FOLDER = Path.of('src-gen')

	def static IFolder createFolderInProjectIfNecessary(IProject project, String folderName) {
		return Path.of(folderName).fold(project as IContainer) [ lastFolder, newPart |
			lastFolder.getFolder(newPart.eclipsePath).createIfNotExists()
		] as IFolder
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
				location = projectLocation.eclipsePath
			], null)
		]
	}

	/**
	 * Configures the given {@link IProject} to be a java project, i.e. adds the Java nature
	 * and a {@link #JAVA_SOURCE_FOLDER} to the project and registers workpace’s default JRE. If the project already
	 * is a Java project, it will be adapted to have {@link #JAVA_BIN_FOLDER} as output location and its classpath be
	 * appended to include the {@link #JAVA_SOURCE_FOLDER} and the workspace’s default JRE. All other settings will stay
	 *  intact.
	 * <br>
	 * To create the expected {@link IProject}, {@link #createWorkspaceProject} can be used.
	 * 
	 * @param project - the {@link IProject} to initialize as a Java project
	 * @throws CoreException if configuring the project fails
	 */
	def static IJavaProject configureAsJavaProject(IProject project) {
		project.open(new NullProgressMonitor())
		val description = project.getDescription()
		val currentNatureIds = description.natureIds

		if (!description.natureIds.contains(JavaCore.NATURE_ID)) {
			val newNatureIds = newArrayOfSize(currentNatureIds.length + 1)
			System.arraycopy(currentNatureIds, 0, newNatureIds, 0, currentNatureIds.length)
			newNatureIds.set(currentNatureIds.length, JavaCore.NATURE_ID)
			description.setNatureIds(newNatureIds)
			project.setDescription(description, null)
		}

		val javaProject = JavaCore.create(project)

		val binFolder = project.getFolder(JAVA_BIN_FOLDER.eclipsePath).createIfNotExists()
		javaProject.setOutputLocation(binFolder.fullPath, null)

		val newClasspath = javaProject.rawClasspath.filter[entryKind != CPE_SOURCE || path != project.fullPath].toSet
		newClasspath += PreferenceConstants.defaultJRELibrary

		val sourceFolder = project.getFolder(JAVA_SOURCE_FOLDER.eclipsePath).createIfNotExists()
		newClasspath += JavaCore.newSourceEntry(sourceFolder.fullPath)

		javaProject.setRawClasspath(newClasspath, null)

		return javaProject
	}

	/**
	 * Adds a source entry for the {@link #SOURCE_GEN_FOLDER} to the provided {@code javaProject} if it does not exist
	 * yet.
	 */
	def static IJavaProject configureSrcGenFolder(IJavaProject javaProject) {
		val srcGenFolder = javaProject.project.getFolder(SOURCE_GEN_FOLDER.eclipsePath).createIfNotExists()

		val oldClasspath = javaProject.rawClasspath
		if (!oldClasspath.exists[entryKind != CPE_SOURCE || path != srcGenFolder.fullPath]) {
			val newClasspath = newArrayOfSize(oldClasspath.length + 1)
			System.arraycopy(oldClasspath, 0, newClasspath, 0, oldClasspath.length)
			val srcGenEntry = JavaCore.newSourceEntry(srcGenFolder.fullPath, newArrayOfSize(0), newArrayOfSize(0), null,
				#[JavaCore.newClasspathAttribute(IClasspathAttribute.IGNORE_OPTIONAL_PROBLEMS, 'true')])
			newClasspath.set(oldClasspath.length, srcGenEntry)
			javaProject.setRawClasspath(newClasspath, null)
		}

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

	/**
	 * Performs an incremental build of the builder with the given ID for all open
	 * {@link IProject}s in the workspace of the workbench.
	 * 
	 * @param builderId -
	 * 		the ID of the builder to run
	 * @throws IllegalStateException if some error occurs during build
	 */
	def static void buildAllProjectsIncrementally(String builderId) throws IllegalStateException {
		for (IProject project : ResourcesPlugin.workspace.root.projects) {
			if (project.open && hasBuilder(project, builderId)) {
				buildIncrementally(project, builderId)
			}
		}
	}

	/**
	 * Performs an incremental build of the builder with the given ID in the given
	 * {@link IProject}. The project must not be <code>null</code> and must be open.
	 * 
	 * @param project -
	 * 		the {@link IProject} to build
	 * @param builderId -
	 * 		the ID of the builder to run
	 * @throws IllegalStateException if some error occurs during build
	 */
	def static void buildIncrementally(IProject project, String builderId) throws IllegalStateException {
		checkArgument(project !== null, "project must not be null")
		checkState(project.open, "project %s must be open to built", project.name)
		if(LOGGER.isDebugEnabled) LOGGER.debug("Run builder " + builderId + " for project " + project.name)
		try {
			project.build(IncrementalProjectBuilder.INCREMENTAL_BUILD, builderId, null, null)
		} catch (CoreException e) {
			val message = "Could not run builder " + builderId + " for project " + project.name
			LOGGER.error(message, e)
			throw new IllegalStateException(message, e)
		}
	}

	/**
	 * Refreshes the given project and performs an incremental build. The project
	 * must not be <code>null</code> and must be open.
	 * 
	 * @param project -
	 * 		the {@link IProject} to refresh and build
	 * @throws IllegalStateException if some error occurs during refresh or build
	 */
	def static void refreshAndBuildIncrementally(IProject project) {
		checkArgument(project !== null, "project must not be null")
		checkState(project.open, "project %s must be open to be refreshed and built", project.name)
		if(LOGGER.isDebugEnabled) LOGGER.debug("Refresh and build project " + project.name)
		try {
			project.refreshLocal(IResource.DEPTH_INFINITE, null)
		} catch (CoreException e) {
			val message = "Could not refresh project " + project.name
			LOGGER.error(message, e)
			throw new IllegalStateException(message, e)
		}
		try {
			project.build(IncrementalProjectBuilder.INCREMENTAL_BUILD, null)
		} catch (CoreException e) {
			val message = "Could not build project " + project.name
			LOGGER.error(message, e)
			throw new IllegalStateException(message, e)
		}
	}

	/**
	 * Checks whether the given {@link IProject} has a builder with the given ID. The project
	 * must not be <code>null</code> and must be open.
	 * 
	 * @param project -
	 * 		the {@link IProject} to check for the builder
	 * @param builderId -
	 * 		the ID of the builder to check to project for
	 * @return whether the project has a builder with the given ID
	 */
	def static boolean hasBuilder(IProject project, String builderId) {
		checkArgument(project !== null, "project must not be null")
		checkState(project.open, "project %s must be open", project.name)
		try {
			for (ICommand buildSpec : project.description.buildSpec) {
				if (builderId == buildSpec.builderName) {
					return true
				}
			}
		} catch (CoreException e) {
			val message = "Could not read description of project " + project.name
			LOGGER.error(message, e)
			throw new IllegalStateException(message, e)
		}
		return false
	}

}
