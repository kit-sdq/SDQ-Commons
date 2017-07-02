package edu.kit.ipd.sdq.commons.util.java.lang

import java.util.Collection

class StringUtil {
	public static def String join(Collection<String> strings, String separator) {
		return IterableExtensions.join(strings, separator);
	}
	
	public static def String join(String[] strings, String separator) {
		return strings.toList.join(separator);
	}
	
	public static def String repeat(String string, int times) {
		val strBuilder = new StringBuilder();
		for (var i = 0; i < times; i++) {
			strBuilder.append(string);
		}
		return strBuilder.toString
	}
	
	public static def boolean isEmpty(String string) {
		return string === null || string.equals("");
	}
}