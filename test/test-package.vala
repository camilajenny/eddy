int main(string[] args) {
    GLib.Intl.setlocale(LocaleCategory.ALL, "C.UTF-8");

    Test.init(ref args);

    TestSuite package = new TestSuite("package");

    package.add_suite(new CompareVersionsTest().suite);

    /*
     * Run the tests
     */
    TestSuite root = TestSuite.get_root();
    root.add_suite(package);

    int ret = -1;
    Idle.add(() => {
            ret = Test.run();
            Gtk.main_quit();
            return false;
        });

    Gtk.main();
    return ret;
}