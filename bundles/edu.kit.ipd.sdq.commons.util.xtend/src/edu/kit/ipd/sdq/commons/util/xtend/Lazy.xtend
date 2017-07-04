package edu.kit.ipd.sdq.commons.util.xtend

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

/**
 * Lazily initializes a field. A field annotated with {@code @Lazy} will get a
 * public getter that will, when called for the first time in the field’s
 * lifetime execute the field’s initializer. Subsequent calls will use the 
 * computed value.
 * 
 * The initializer is guaranteed to be called at the first access and only
 * once.
 * 
 * There are some restrictions for fields that are annotated as being 
 * {@code @Lazy}:
 * 
 * <ul>
 * <li>They must have an initializer (obviously)
 * <li>They must be private
 * </ul>
 * 
 * The field itself will be prepended with an underscore to make sure it
 * is not accessed directly
 * 
 * This annotation was inspired by 
 * {@link https://github.com/eclipse/xtext-xtend/blob/master/org.eclipse.xtend.examples/projects/xtend-annotation-examples/src/lazy/Lazy.xtend
 * The Lazy annotation from Xtext’s active annotations example}
 * 
 * @author Joshua Gleitze
 */
@Target(ElementType.FIELD)
@Active(LazyProcessor)
annotation Lazy {
}

class LazyProcessor extends AbstractFieldProcessor {

	override doTransform(MutableFieldDeclaration field, extension TransformationContext context) {
		if (field.initializer === null)
			field.addError("A lazy field must have an initializer.")
			
		if (field.visibility != Visibility.PRIVATE)
			field.addError("A lazy field must be private!")
		
		val isInited = field.declaringType.addField('''__«field.simpleName»_isInitialised''') [
			type = context.primitiveBoolean
			initializer = '''false'''
			visibility = Visibility.PRIVATE
			static = field.static
			primarySourceElement = field
		]
		
		val initializer = field.declaringType.addMethod('''__«field.simpleName»_initialise''') [
			returnType = field.type
			static = field.static
			visibility = Visibility.PRIVATE
			body = field.initializer
		]
		
		field.declaringType.addMethod('get' + field.simpleName.toFirstUpper) [
			field.markAsRead
			field.initializer
			returnType = field.type
			static = field.static
			body = '''
				if (!«isInited.simpleName») {
					«isInited.simpleName» = true;
					«field.simpleName» = «initializer.simpleName»();
				}
				return «field.simpleName»;
			'''
			primarySourceElement = field
		]

		field.simpleName = '''_«field.simpleName»'''
		field.final = false
	}

}
