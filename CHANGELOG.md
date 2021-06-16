# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.2.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.1.0...v5.2.0) (2021-06-16)


### Features

* Add support for creating BigQuery routines ([#124](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/124)) ([0d11437](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/0d11437b0e5e486a138b06ddcfb9ad47d9170b05))


### Bug Fixes

* Loosen version constraint on Google provider ([#128](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/128)) ([cb6aaa4](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/cb6aaa4efd59e653a2fb6beb5c975621c5ecff02))

## [5.1.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.0.0...v5.1.0) (2021-05-06)


### Features

* add feature deletion_protection in bigquery table ([#114](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/114)) ([f56f444](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/f56f44486227e66263e1cc81ff3cb2b68d1c6651))


### Bug Fixes

* Add missing equals sign ([#116](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/116)) ([b1f8423](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/b1f842371e47ca8b78b232920cc569d4562c36be))
* Prevent forcing table recreation after dataset table list modification with enabled encryption ([#121](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/121)) ([06cc7e0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/06cc7e0b8fdc6c53f8632bb4eecb06e456f45343))

## [5.0.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.5.0...v5.0.0) (2021-03-15)


### ⚠ BREAKING CHANGES

* Add Terraform 0.13 constraint and module attribution (#112)
* Schema should now be passed as a JSON string instead of a file path (#111)
* Table configuration must now specify `range_partitioning = null` to preserve old defaults.

### Features

* Add range partitioning support ([#109](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/109)) ([66311eb](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/66311eb65ee4e9762c1b97840c806d4299e37c89))
* Add Terraform 0.13 constraint and module attribution ([#112](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/112)) ([7cd92fe](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/7cd92fe31aaded94677091daefada1c2cbc45d41))
* Schema should now be passed as a JSON string instead of a file path ([#111](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/111)) ([7180061](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/71800616c9ebe3acab6e44731432e2bfe4f02b3c))

## [4.5.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.4.0...v4.5.0) (2021-02-17)


### Features

* Add support for external tables ([#105](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/105)) ([bbb166d](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/bbb166dee9a006df682581e9ab7d85a5ee1e9227))

## [4.4.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.3.0...v4.4.0) (2020-12-04)


### Features

* Added CMEK support ([#92](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/92)) ([392f735](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/392f735c05f7305743792017eff0f792d62ea5dd))


### Bug Fixes

* Fixed automated tests ([#94](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/94)) ([862b8b6](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/862b8b6c1e5dfbbce57d4d585fb42eb82a68b980))

## [4.3.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.2.1...v4.3.0) (2020-07-27)


### Features

* Add var.delete_contents_on_destroy to enable deleting non-empty datasets ([#78](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/78)) ([4bd5f82](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/4bd5f82da82d9c4063a60e9564a87737d9e914ec))


### Bug Fixes

* Allow running module on terraform 0.13.0-rc1  ([#85](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/85)) ([43fa15b](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/43fa15bd86b1ba004b3163ce504e29eb251f1da6))

### [4.2.1](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.2.0...v4.2.1) (2020-05-27)


### Bug Fixes

* Enable granting access for duplicate roles on auth module ([#74](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/74)) ([ade8d3f](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/ade8d3fd6d19d68fdb49b5ac86271eebdc9c5724))
* Use fully scoped keys for views in Terraform ([#72](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/72)) ([c80e1a4](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/c80e1a411d7fc587d3802d7eb6847efa3c455dae))

## [4.2.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.1.1...v4.2.0) (2020-05-13)


### Features

* Add view support to bigquery module ([#64](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/64)) ([18bfdd6](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/18bfdd62421f3a98a9e72f0dd3e88c997b837d97))

### [4.1.1](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.1.0...v4.1.1) (2020-05-06)


### Bug Fixes

* Map dataEditor to WRITER role ([#65](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/65)) ([cdba2e6](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/cdba2e694702de54ee20f87697e5d8b6d6c10247))

## [4.1.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.0.1...v4.1.0) (2020-04-28)


### Features

* add conversion between iam and primitive roles ([#62](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/62)) ([f454638](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/f454638175bfb429250697beea7e8ade3d634679))

### [4.0.1](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v4.0.0...v4.0.1) (2020-04-23)


### Bug Fixes

* Switch default access to use legacy role ([#60](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/60)) ([f7e2658](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/f7e265858c3374112f465b84ffe947dc2ab50510)), closes [/github.com/terraform-providers/terraform-provider-google/issues/5350#issuecomment-607533636](https://www.github.com/terraform-google-modules//github.com/terraform-providers/terraform-provider-google/issues/5350/issues/issuecomment-607533636)

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
