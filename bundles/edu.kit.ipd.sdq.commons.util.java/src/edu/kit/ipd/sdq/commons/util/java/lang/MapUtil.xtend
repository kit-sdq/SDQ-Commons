package edu.kit.ipd.sdq.commons.util.java.lang

import java.util.Collection
import java.util.Map
import org.eclipse.xtext.xbase.lib.Functions.Function0
import java.util.List
import org.eclipse.xtext.xbase.lib.Functions.Function2
import java.util.ArrayList
import edu.kit.ipd.sdq.activextendannotations.Utility

/**
 * A utility class providing extension methods for maps
 * 
 * TODO check whether Apache Common's MultiValuedMap is sufficient and also convenient:
 * https://commons.apache.org/proper/commons-collections/apidocs/org/apache/commons/collections4/MultiValuedMap.html
 */
@Utility
class MapUtil {
	def static final <K,V,C extends Collection<V>> C add(Map<K,C> map, K key, V value, Function0<C> constructor) {
		val newCollection = constructor.apply()
		newCollection.add(value)
		return addAll(map, key, newCollection, constructor)
	}
	
	def static final <K,V,C extends Collection<V>> C addAll(Map<K,C> map, K key, C values, Function0<C> constructor) {
		var mappedValueCollection = map.get(key)
		if (mappedValueCollection === null) {
			mappedValueCollection = constructor.apply
			map.put(key,mappedValueCollection)
		}
		mappedValueCollection.addAll(values)
		return mappedValueCollection
	}
	
	def static final <K, C extends Collection<?>> boolean onlyEmptyCollectionsMapped(Map<K,C> map) {
		return map?.values?.flatten().empty
	}
	
	def static final <K,V,C extends Collection<V>> boolean containsAll(Map<K,C> map1, Map<K,C> map2) {
		map2?.mapFixed[key,value|containsAll(map1, key, value)].forall[it == true]
	}
	
	def static final <K,V,C extends Collection<V>> boolean containsAll(Map<K,C> map, K key, C values) {
		if (map === null) return false 
		else if (map.get(key) === null) return false 
		else return map.get(key).containsAll(values)
	}
	
	static final def <K,V,R> List<R> mapFixed(Map<K,V> map, Function2<? super K, ? super V, ? extends R> transformation) {
		val List<R> list = new ArrayList()
		for (mapEntry : map.entrySet) {
			list.add(transformation.apply(mapEntry.key, mapEntry.value))
		}
		return list
	}
}