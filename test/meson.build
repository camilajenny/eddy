test_deps = [
    vala_unit_dep
]

test_package_sources = [
    'test-package.vala',

    'package/compare-versions-test.vala',

    meson.project_source_root() + '/src/EddyUtils.vala',
]

test_package_bin = executable(
    'package-tests',
    test_package_sources,
    dependencies: deps + vala_unit_dep,
    install: false
)

test('package tests', test_package_bin)