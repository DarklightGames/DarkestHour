from unittest import TestCase

from data import LocalizationData


class LocalizationDataTests(TestCase):
    def test_new_from_po_contents(self):
        # Test that the localization data is valid
        contents = """
        msgid "Section.Key"
        msgstr "Value"
        """
        localization_data = LocalizationData.new_from_po_contents(contents)

        self.assertTrue('Section' in localization_data.sections, 'Section not found')

    def test_new_from_unt_contents(self):
        contents = """
        [Section]
        Key=Value
        """
        localization_data = LocalizationData.new_from_unt_contents(contents)

        self.assertTrue('Section' in localization_data.sections, 'Section not found')

    def test_po_parsing(self):
        contents = """
        msgid "Section.ArrayKey<0>"
        msgstr "My"
        
        msgid "Section.ArrayKey<1>"
        msgstr "Cool"
        
        msgid "Section.ArrayKey<2>"
        msgstr "Array"
        """
        localization_data = LocalizationData.new_from_po_contents(contents)

        self.assertTrue('Section' in localization_data.sections, 'Section not found')

        section = localization_data.sections['Section']

        self.assertEqual(section['ArrayKey'], ['My', 'Cool', 'Array'], 'Array not as expected')

    def test_unt_parsing(self):
        contents = """
        [Section]
        StringKey="This is a quoted string"
        StringKeyNoQuotes=This is a non-quoted string
        ArrayKey=("My","Cool","Array")
        ArrayKeyWithTrailingEmpty=("My","Cool","Array",)
        ArrayKeyWithAllEmpties=(,,)
        StructKey=(Key1=Value1,Key2=Value2)
        NestedStructKey=(Key1=Value1,Key2=(Key3=Value3,Key4=Value4))
        ArrayOfStructs=((Key1=Value1,Key2=Value2),(Key3=Value3,Key4=Value4))
        """

        localization_data = LocalizationData.new_from_unt_contents(contents)

        self.assertTrue('Section' in localization_data.sections, 'Section not found')

        section = localization_data.sections['Section']

        self.assertEqual(section['StringKey'], 'This is a quoted string', 'String not as expected')
        self.assertEqual(section['StringKeyNoQuotes'], 'This is a non-quoted string', 'String not as expected')
        self.assertEqual(section['ArrayKey'], ['My', 'Cool', 'Array'], 'Array not as expected')
        self.assertEqual(section['ArrayKeyWithTrailingEmpty'], ['My', 'Cool', 'Array', None], 'Array not as expected')
        self.assertEqual(section['ArrayKeyWithAllEmpties'], [None, None, None], 'Array not as expected')
        self.assertEqual(section['StructKey'], {'Key1': 'Value1', 'Key2': 'Value2'}, 'Struct not as expected')
        self.assertEqual(section['NestedStructKey'], {'Key1': 'Value1', 'Key2': {'Key3': 'Value3', 'Key4': 'Value4'}}, 'Struct not as expected')
        self.assertEqual(section['ArrayOfStructs'], [{'Key1': 'Value1', 'Key2': 'Value2'}, {'Key3': 'Value3', 'Key4': 'Value4'}, ], 'Array of structs not as expected')

    def test_remove_empty_dynamic_arrays(self):
        contents = """
        [Section]
        Key1=("My","Cool","Array")
        Key2=(,,)
        NestedKey=(String="Foo",EmptyArray=(,,))
        """

        localization_data = LocalizationData.new_from_unt_contents(contents)

        section = localization_data.sections['Section']

        value1 = section['Key1']
        value2 = section['Key2']

        self.assertEqual(value1, ['My', 'Cool', 'Array'], 'Array not as expected')
        self.assertEqual(value2, [None, None, None], 'Array not as expected')

        # Remove empty dynamic arrays
        localization_data.remove_empty_dynamic_arrays()

        # Assert
        self.assertTrue('Key1' in section, 'Key1 should not have been removed')
        self.assertTrue('Key2' not in section, 'Key2 should have been removed')
        self.assertTrue('NestedKey' in section, 'NestedKey should not have been removed')
        self.assertTrue('EmptyArray' not in section['NestedKey'], 'EmptyArray should have been removed')
