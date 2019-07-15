/*
 * generated by Xtext 2.17.0
 */
package app.hypermedia.testing.dsl.generator

import app.hypermedia.testing.dsl.core.ClassBlock
import app.hypermedia.testing.dsl.core.TopLevelStep
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import app.hypermedia.testing.dsl.core.PropertyBlock
import app.hypermedia.testing.dsl.core.PropertyStatement
import org.apache.commons.lang3.NotImplementedException
import org.eclipse.emf.ecore.EObject
import app.hypermedia.testing.dsl.Modifier
import app.hypermedia.testing.dsl.core.StatusStatement
import app.hypermedia.testing.dsl.core.RelaxedLinkBlock
import app.hypermedia.testing.dsl.core.StrictLinkBlock
import app.hypermedia.testing.dsl.core.LinkStatement

/**
 * Generates code from your model files on save.
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class CoreGenerator extends AbstractGenerator {

    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {

        val Iterable<EObject> blocks = resource.allContents.filter(TopLevelStep).toList

        if ( ! blocks.empty) {
            val String dslFileName = resource.getURI().lastSegment.toString();

            fsa.generateFile(dslFileName + '.json', generateSteps(blocks));
        }
    }

    def generateSteps(Iterable<EObject> blocks) '''
        {
            "steps": [
                «FOR block:blocks SEPARATOR ","»
                    «block.step»
                «ENDFOR»
            ]
        }
    '''

    def dispatch step(ClassBlock it) '''
        {
            "type": "Class",
            "classId": "«name»",
            "children": [
                «FOR step:children SEPARATOR ","»
                    «step.step»
                «ENDFOR»
            ]
            «hatch»
        }
    '''

    def dispatch step(PropertyBlock it)  '''
        {
            "type": "Property",
            "propertyId": "«name»",
            "children": [
                «FOR step:children SEPARATOR ","»
                    «step.step»
                «ENDFOR»
            ],
            "strict": «if (modifier == Modifier.WITH) {
            	false
            } else {
            	true
            }»
            «hatch»
        }
    '''

    def dispatch step(PropertyStatement it)  '''
        {
            "type": "Property",
            "propertyId": "«name»",
            «IF value !== null»
                "value": "«value»",
            «ENDIF»
            "strict": true
        }
    '''

    def dispatch step(StatusStatement it)  '''
        {
            "type": "ResponseStatus",
            "code": «status»
        }
    '''
    
    def dispatch step(RelaxedLinkBlock it)'''
        {
            "type": "Link",
            "strict": false,
            "rel": "«relation»",
            "children": [
                «FOR step:children SEPARATOR ","»
                    «step.step»
                «ENDFOR»
            ]
        }
    '''
    
    def dispatch step(StrictLinkBlock it)'''
        {
            "type": "Link",
            "strict": true,
            "rel": "«relation»",
            "children": [
                «FOR step:children SEPARATOR ","»
                    «step.step»
                «ENDFOR»
            ]
        }
    '''
    
    def dispatch step(LinkStatement it)'''
        {
            "type": "Link",
            "strict": true,
            "rel": "«relation»"
        }
    '''

    def dispatch step(EObject step) {
        throw new NotImplementedException(String.format("Unrecognized step %s", step.class))
    }
}
