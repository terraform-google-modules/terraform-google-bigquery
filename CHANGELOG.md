# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v3.0.0...v4.0.0) (2020-02-19)
This is a backwards-incompatible release. See the [migration guide](./docs/upgrading_to_bigquery_v4.0.md) for details.

### ⚠ BREAKING CHANGES

* The udfs submodule has been removed from the BQ submodule. You should now invoke it separately.
* Some output values were changed and/or removed entirely.
* Dataset access can now be managed via this module. By default the module now grants project owners the `bigquery.dataOwner` role (including on existing datasets). See the [migration guide](./docs/upgrading_to_bigquery_v4.0.md) for details.
* The minimum Google provider version has been
updated to 3.0.

### Features

* Add support for managing access (`var.access`) ([#48](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/48)) ([f2ea257](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/f2ea25765dc68b8e24a0f02b62aea938faf5768f))
* Set types on vars and make optional ones actually optional ([#49](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/49)) ([0367d69](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/0367d69e9cf2dd9a36c929975c75f3f70d61197f))
* Update google provider version to 3.0 ([71d776c](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/71d776c77c9bef53ccfa230cf10cbd56896d36f4))


### Bug Fixes

* Removed broken and unnecessary outputs ([#47](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/47)) ([a130ad9](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/a130ad91c4dc2366230b1f6bd3177b1117ff6757))


### Miscellaneous Chores

* Separate main bq module from udfs ([#50](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/50)) ([9795928](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/97959280ffa5653d1515b3fc4a9b2fe759ccfc77))

## [Unreleased]

## [3.0.0] 2019-12-05

-  Add support for `clustering` on a table basis [Issue #26](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/26)
-  `count` is replaced with for_each [Issue #39](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/39)
-  The `expiration` variable renamed to `default_table_expiration_ms` [#40]
-  `expiration_time` can be specified on a table basis [#40]
-  `partitioning` now can be specified on a table basis and started to be optional, also started supporting additional parameters
-  Outputs updated to output the whole resources instead of attributes [#40]

## [2.0.0] 2019-08-02

### Changed

- Supported version of Terraform is 0.12. [#17]
- The `table_labels` variable was replaced with a `labels` key in the `tables` variable object structure. [#20]
- The `expiration` variable has a `null` default. [#23]

## [1.0.0] 2019-05-29

### Changed
- Module ONLY accepts a _list of maps_ for the table_name, table_id, and schema. This enables the creation of multiple tables on a single dataset.
- Inspec attributes for testing in inspec.yml
- Examples for multiple tables per [Issue #5](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/5)
- Testing with native inspec resources per [Issue #7](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/7)
- Support for multiple tables per [Issue #6](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/6)
- Examples to support google provider >2.5.0 per [Issue #8](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/8)
- Upgraded Gemfile/Gemfile.lock for kitchen-terraform gems
- Module output for table name

[1.0.0]: https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v1.0.0...HEAD

## [0.1.0] 2019-02-12

### Added

- This is the initial release of the Big Query module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-bigquery/releases/tag/v0.1.0/

[#40]: https://github.com/terraform-google-modules/terraform-google-bigquery/pulls/40
[#23]: https://github.com/terraform-google-modules/terraform-google-bigquery/pulls/23
[#20]: https://github.com/terraform-google-modules/terraform-google-bigquery/pulls/20
[#17]: https://github.com/terraform-google-modules/terraform-google-bigquery/pulls/17
