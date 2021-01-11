package edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources

import edu.kit.ipd.sdq.activextendannotations.Utility
import org.eclipse.core.runtime.IPath
import java.nio.file.Path

@Utility
class IPathUtil {
	static def IPath getEclipsePath(Path path) {
		new org.eclipse.core.runtime.Path(path.toString)
	}
}