"""Chạy: python -m unittest discover -s scripts/gold"""

import unittest

from import_ratings import parse_row
from metrics import (content_score, length_baseline_qwk, mean_absolute_error, quadratic_weighted_kappa,
                     select_items, spearman)


class QuadraticWeightedKappaTest(unittest.TestCase):
    def test_identical_ratings_give_one(self):
        self.assertAlmostEqual(quadratic_weighted_kappa([1, 2, 3, 4, 5], [1, 2, 3, 4, 5]), 1.0)

    def test_reversed_ratings_give_minus_one(self):
        self.assertAlmostEqual(quadratic_weighted_kappa([1, 2, 3, 4, 5], [5, 4, 3, 2, 1]), -1.0)

    def test_hand_computed_value(self):
        # Tổng bình phương độ lệch: quan sát 1, kỳ vọng 32 / 4 = 8, nên QWK = 1 - 1 / 8
        self.assertAlmostEqual(quadratic_weighted_kappa([1, 2, 3, 4], [1, 2, 3, 3]), 0.875)

    def test_larger_error_is_penalised_more(self):
        near = quadratic_weighted_kappa([1, 2, 3, 4, 5], [1, 2, 3, 4, 4])
        far = quadratic_weighted_kappa([1, 2, 3, 4, 5], [1, 2, 3, 4, 1])
        self.assertGreater(near, far)

    def test_constant_ratings_are_undefined(self):
        self.assertIsNone(quadratic_weighted_kappa([3, 3], [3, 3]))


class SpearmanTest(unittest.TestCase):
    def test_monotonic_gives_one(self):
        self.assertAlmostEqual(spearman([1, 2, 3], [10, 200, 3000]), 1.0)

    def test_ties_use_average_rank(self):
        self.assertAlmostEqual(spearman([1, 2, 2, 3], [1, 2, 3, 4]), 0.9486833, places=6)

    def test_constant_series_is_undefined(self):
        self.assertIsNone(spearman([1, 1], [1, 2]))


class ContentScoreTest(unittest.TestCase):
    def test_all_five_is_hundred_and_all_one_is_zero(self):
        top = {"scores": {"RELEVANCE": 5, "STRUCTURE": 5, "DEPTH": 5}}
        low = {"scores": {"RELEVANCE": 1, "STRUCTURE": 1, "DEPTH": 1}}
        self.assertAlmostEqual(content_score("INTRO", top), 100.0)
        self.assertAlmostEqual(content_score("INTRO", low), 0.0)

    def test_weights_are_renormalised_without_delivery(self):
        label = {"scores": {"RELEVANCE": 5, "STRUCTURE": 1, "DEPTH": 1}}
        self.assertAlmostEqual(content_score("BEHAVIORAL", label), 20 / 90 * 100)

    def test_off_topic_caps_at_thirty(self):
        label = {"scores": {"RELEVANCE": 5, "STRUCTURE": 5, "DEPTH": 5}, "off_topic": True}
        self.assertEqual(content_score("BEHAVIORAL", label), 30.0)


class MeanAbsoluteErrorTest(unittest.TestCase):
    def test_average_of_differences(self):
        self.assertEqual(mean_absolute_error([1, 2], [2, 4]), 1.5)


class LengthBaselineTest(unittest.TestCase):
    @staticmethod
    def dataset(pairs):
        items = [{"id": str(i), "word_count": words} for i, (words, _) in enumerate(pairs)]
        ref = {str(i): {"scores": {"DEPTH": score}} for i, (_, score) in enumerate(pairs)}
        return items, ref

    def test_score_fully_explained_by_length_gives_one(self):
        items, ref = self.dataset([(10, 1), (20, 2), (30, 3), (40, 4), (50, 5)])
        self.assertAlmostEqual(length_baseline_qwk(items, ref, "DEPTH"), 1.0)

    def test_score_opposite_to_length_gives_minus_one(self):
        items, ref = self.dataset([(10, 5), (20, 4), (30, 3), (40, 2), (50, 1)])
        self.assertAlmostEqual(length_baseline_qwk(items, ref, "DEPTH"), -1.0)


class SelectItemsTest(unittest.TestCase):
    GOLD = [
        {"id": "A", "split": "calibration", "rating_set": True},
        {"id": "B", "split": "calibration", "rating_set": False},
        {"id": "C", "split": "holdout", "rating_set": True},
    ]

    def test_unrated_item_is_skipped_when_reference_lacks_it(self):
        chosen = select_items(self.GOLD, {"A": {}}, "calibration")
        self.assertEqual([item["id"] for item in chosen], ["A"])

    def test_item_is_kept_when_reference_has_it(self):
        chosen = select_items(self.GOLD, {"A": {}, "B": {}}, "calibration")
        self.assertEqual([item["id"] for item in chosen], ["A", "B"])

    def test_missing_rated_item_stays_so_validation_reports_it(self):
        chosen = select_items(self.GOLD, {}, "calibration")
        self.assertEqual([item["id"] for item in chosen], ["A"])

    def test_split_filter_applies(self):
        chosen = select_items(self.GOLD, {"A": {}, "C": {}}, "holdout")
        self.assertEqual([item["id"] for item in chosen], ["C"])


class ParseRowTest(unittest.TestCase):
    ROW = {"id": "GOLD-001", "question_type": "BEHAVIORAL", "RELEVANCE": "4", "STRUCTURE": "3", "DEPTH": "2",
           "CORRECTNESS": "N/A", "off_topic": ""}

    def test_valid_row_ignores_correctness_outside_technical(self):
        label, problems = parse_row(self.ROW)
        self.assertEqual(problems, [])
        self.assertEqual(label["scores"], {"RELEVANCE": 4, "STRUCTURE": 3, "DEPTH": 2})
        self.assertFalse(label["off_topic"])

    def test_technical_requires_correctness(self):
        _, problems = parse_row({**self.ROW, "question_type": "TECHNICAL", "CORRECTNESS": ""})
        self.assertEqual(len(problems), 1)
        self.assertIn("CORRECTNESS", problems[0])

    def test_score_outside_scale_is_reported(self):
        _, problems = parse_row({**self.ROW, "DEPTH": "6"})
        self.assertIn("DEPTH", problems[0])

    def test_off_topic_mark_is_read(self):
        label, _ = parse_row({**self.ROW, "off_topic": "x"})
        self.assertTrue(label["off_topic"])


if __name__ == "__main__":
    unittest.main()
