package edu.kit.ipd.sdq.commons.util.java.lang

import java.util.Collection
import edu.kit.ipd.sdq.activextendannotations.Utility

@Utility
class StringUtil {
	static def String join(Collection<String> strings, String separator) {
		return IterableExtensions.join(strings, separator);
	}
	
	static def String join(String[] strings, String separator) {
		return strings.toList.join(separator);
	}
	
	static def String repeat(String string, int times) {
		val strBuilder = new StringBuilder();
		for (var i = 0; i < times; i++) {
			strBuilder.append(string);
		}
		return strBuilder.toString
	}
	
	static def boolean isEmpty(String string) {
		return string === null || string.equals("");
	}
}