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
    def setUp(self):
        with open("test/resources/view_ut_schema.json", "r") as schema:
          self.source_schema = json.loads(schema.read())
          
    def test_view_no_blacklist(self):
        """Tests the success scenarios for build_unnest_str method."""
        expected_case1 = \
            "IF(ac is null, null, ARRAY(SELECT AS STRUCT ac.a_account,ac.a_ad FROM UNNEST(ac) AS ac)) as ac,IF(accr is null, null, STRUCT(accr.a_line_item,accr.e_id)) as accr,HOUR_TIMESTAMP"
        actual_case1 = bigquery_view_generator.view_columns_builder(self.source_schema,
                                                                    "")
        self.assertEqual(expected_case1, actual_case1)

    def test_view_with_blacklist(self):
        blacklist = "e_id,a_ad"
        expected_case2 = \
            "IF(ac is null, null, ARRAY(SELECT AS STRUCT ac.a_account FROM UNNEST(ac) AS ac)) as ac,IF(accr is null, null, STRUCT(accr.a_line_item)) as accr,HOUR_TIMESTAMP"
        actual_case2 = bigquery_view_generator.view_columns_builder(
            self.source_schema, blacklist)
        self.assertEqual(expected_case2, actual_case2)

if __name__ == '__main__':
    unittest.main()

