package app.hypermedia.testing.dsl.conversion

import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode

class VariableReferenceConverter implements IValueConverter<String> {
    final String INVALID_VALUE_ERROR = "Variable must be string enclosed with brackets"

    override toString(String value)
        '''[«value»]'''

    override toValue(String string, INode node) throws ValueConverterException {
        if (string === null) {
            return null
        }

        if(string.length < 3 || !string.startsWith("[") || !string.endsWith("]")) {
            throw new ValueConverterException(INVALID_VALUE_ERROR, node, null)
        }

        return string.substring(1, string.length - 1)
    }
}