/*
 * generated by Xtext 2.18.0
 */
package app.hypermedia.testing.dsl.tests.hydra

import app.hypermedia.testing.dsl.hydra.OperationBlock
import app.hypermedia.testing.dsl.core.Model
import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import static org.junit.Assert.assertEquals
import app.hypermedia.testing.dsl.tests.HydraInjectorProvider
import static org.assertj.core.api.Assertions.*
import app.hypermedia.testing.dsl.hydra.InvocationBlock
import app.hypermedia.testing.dsl.tests.TestHelpers
import app.hypermedia.testing.dsl.core.ClassBlock
import app.hypermedia.testing.dsl.Modifier
import app.hypermedia.testing.dsl.hydra.RelaxedOperationBlock

@ExtendWith(InjectionExtension)
@InjectWith(HydraInjectorProvider)
class OperationParsingTest {
    @Inject
    ParseHelper<Model> parseHelper

    @Test
    def void withOperationOnTopLevel_ParsesName() {
        // when
        val result = parseHelper.parse('''
            With Operation "CreateUser" {

            }
        ''')

        // then
        TestHelpers.assertModelParsedSuccessfully(result)

        val classBlock = result.steps.get(0) as RelaxedOperationBlock
        assertEquals(classBlock.name, "CreateUser")
    }

    @Test
    def void withOperationOnTopLevelWithInvocation_ParsesSuccessfully() {
        // when
        val result = parseHelper.parse('''
            With Operation "CreateUser" {
                Invoke {
                }

                Invoke {
                }

                Invoke {
                }
            }
        ''')

        // then
        TestHelpers.assertModelParsedSuccessfully(result)

        val operationBlock = result.steps.get(0) as RelaxedOperationBlock
        assertThat(operationBlock.invocations).hasSize(3)
        val invokeBlock = operationBlock.invocations.get(0)
        assertThat(invokeBlock).isInstanceOf(InvocationBlock)
    }

    @Test
    def void expectOperation_ParsesSuccessfullyWhenNested() {
        // when
        val result = parseHelper.parse('''
            With Class "Foo" {
                Expect Operation "CreateUser" {
                }
            }
        ''')

        // then
        TestHelpers.assertModelParsedSuccessfully(result)

        val classBlock = result.steps.get(0) as ClassBlock
        val operationBlock = classBlock.children.get(0) as OperationBlock
        assertThat(operationBlock).isInstanceOf(OperationBlock)
        assertThat(operationBlock.modifier).isEqualTo(Modifier.EXPECT)
    }

    @Test
    def void expectOperation_ParsingFailsOnTopLevel() {
        // when
        val result = parseHelper.parse('''
            Expect Operation "CreateUser" {
            }
        ''')

        // then
       assertThat(result).isNull()
    }

    @Test
    def void withOperation_ParsesSuccessfullyWhenNested() {
        // when
        val result = parseHelper.parse('''
            With Class "Foo" {
                With Operation "CreateUser" {
                }
            }
        ''')

        // then
        TestHelpers.assertModelParsedSuccessfully(result)

        val classBlock = result.steps.get(0) as ClassBlock
        val operationBlock = classBlock.children.get(0) as OperationBlock
        assertThat(operationBlock).isInstanceOf(OperationBlock)
        assertThat(operationBlock.modifier).isEqualTo(Modifier.WITH)
    }
}
