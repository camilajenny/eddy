// SPDX-License-Identifier: LGPL-2.1-or-later
// Minimal test file for vala-unit

using ValaUnit;

class CompareVersionsTest : ValaUnit.TestCase {

    delegate int Compare(string v1, string v2);
    Compare compare = EddyUtils.compare_versions;

    public CompareVersionsTest() {
        base("CompareVersionsTest");

        add_test("epoch_comparisons", epoch_comparisons);
        add_test("tilde_sorting", tilde_sorting);
        add_test("ubuntu_suffix_comparisons", ubuntu_suffix_comparisons);
        add_test("basic_comparisons", basic_comparisons);
        add_test("debian_revision_comparisons", debian_revision_comparisons);
        add_test("equal_versions", equal_versions);
    }

    void test_greater_method(string left, string right) {
        int result = compare(left, right);
        assert_compare_gt(result, "$left should be greater than $right");
    }

    void test_equal_method(string left, string right) {
        int result = compare(left, right);
        assert_compare_eq(result, "$left should be equal to $right");
    }

    void epoch_comparisons() throws GLib.Error {
        test_greater_method("1:1.0", "0:2.0");
        test_greater_method("10:2.0", "3:2.0");
        test_greater_method("1:1.2.3", "1.2.3");
    }

    void tilde_sorting() throws GLib.Error {
        test_greater_method("2.0", "2.0~beta1");
        test_greater_method("2.1~beta", "2.0");
        test_greater_method("1.0.0", "1.0.0~"); // trailing tilde means it's earlier
        test_greater_method("1.2.3-4", "1.2.3-4~beta1");
        test_greater_method("2.0~rc2", "2.0~rc1");
        test_greater_method("3.4.1", "3.4.1~rc1");
        test_greater_method("1.0.0-1", "1.0.0~rc1-1");
    }

    void ubuntu_suffix_comparisons() throws GLib.Error {
        test_greater_method("1.0.0-1ubuntu2", "1.0.0-1ubuntu1");
        test_greater_method("1.0.0-1ubuntu2", "1.0.0-1");
        test_greater_method("1.0.0-0ubuntu2", "1.0.0-0ubuntu1");
        test_greater_method("1.0.0-0ubuntu1", "1.0.0-0");
        test_greater_method("1.0.0-0ubuntu2build2", "1.0.0-0ubuntu2build1");
    }

    void basic_comparisons() throws GLib.Error {
        test_greater_method("1.2.3", "1.2.2");
        test_greater_method("1.2.10", "1.2.2");
        test_greater_method("2.4.5", "2.4");
        test_greater_method("1.0+git20240501", "1.0");
    }

    void debian_revision_comparisons() throws GLib.Error {
        test_greater_method("1.0.0-10", "1.0.0-3");
        test_greater_method("1.2.3-2", "1.2.3-1");
    }

    void equal_versions() throws GLib.Error {
        test_equal_method("0:2.4.1", "2.4.1");
        test_equal_method("1.2.3", "1.2.3");
        test_equal_method("1.0.0-1", "1.0.0-1");
        test_equal_method("1.2.3+git", "1.2.3+git");
    }
}


