"""
This is a Unitest class for bigquery_view_generator.py.
The function view_columns_builder is tested for all success cases
The unit test class depends on view_ut_schema.json file to run
"""

import json
import unittest
import bigquery_view_generator


class TestBigqueryViewGenerator(unittest.TestCase):
    """Test suite for UDF command line generator utility."""

    def test_view_builder_pass(self):
        """Tests the success scenarios for build_unnest_str method."""

        source_schema = json.loads(open("test/resources/view_ut_schema.json", "r").read())
        # Test with no blacklist.
        expected_case1 = \
            "ARRAY(SELECT AS STRUCT ac.a_account,ac.a_ad FROM UNNEST(ac) AS ac) ac,STRUCT(accr.a_line_item,accr.e_id) as accr,HOUR_TIMESTAMP"
        actual_case1 = bigquery_view_generator.view_columns_builder(source_schema,
                                                                    "")
        self.assertEqual(expected_case1, actual_case1)

        blacklist = "e_id,a_ad"

        # Test with blacklist.
        expected_case2 = \
            "ARRAY(SELECT AS STRUCT ac.a_account FROM UNNEST(ac) AS ac) ac,STRUCT(accr.a_line_item) as accr,HOUR_TIMESTAMP"
        actual_case2 = bigquery_view_generator.view_columns_builder(
            source_schema, blacklist)
        self.assertEqual(expected_case2, actual_case2)

if __name__ == '__main__':
    unittest.main()
