package app.hypermedia.testing.dsl.ide.tests.editor.contentassist

import org.junit.jupiter.api.Test
import org.eclipse.xtext.testing.AbstractLanguageServerTest

class CoreCompletionTest extends AbstractLanguageServerTest {
    
    new() {
        super("api")
    }
    
    @Test
    def void testCompletion_01() {
        testCompletion [
            model = ''
            expectedCompletionItems = '''
				With Class -> With Class [[0, 0] .. [0, 0]]
			'''
        ]
    }
}
