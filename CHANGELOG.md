# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [10.1.1](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v10.1.0...v10.1.1) (2025-06-06)


### Bug Fixes

* update display metadata to fix regex for bigquery dataset id [#392](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/392) ([2f7acb8](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/2f7acb889f1439ecffba84b060f02d2392005558))
* Upgrade gemin model used in data_warehouse ([#397](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/397)) ([e383c94](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/e383c942fb21da0d6592a306543558f79ae834f0))

## [10.1.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v10.0.2...v10.1.0) (2025-03-26)


### Features

* Adding regex validation for big query dataset id and adding new output value computed_table_id ([#384](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/384)) ([aab8238](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/aab82382cbf67a3b7e1af801f80c3113592d4193))

## [10.0.2](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v10.0.1...v10.0.2) (2025-03-14)


### Bug Fixes

* Use list(string) instead of tuple for some of the output variables ([#380](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/380)) ([4d525f4](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/4d525f453ac291c18f4843da4bbf1483daf4b72e))

## [10.0.1](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v10.0.0...v10.0.1) (2025-03-06)


### Bug Fixes

* Make non-required object fields as optional for input variables ([#377](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/377)) ([cd4ab5e](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/cd4ab5e03d992556e7eba4860e716f742c142fb7))

## [10.0.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v9.0.0...v10.0.0) (2025-03-03)


### ⚠ BREAKING CHANGES

* **deps:** Update Terraform terraform-google-modules/project-factory/google to v18 ([#366](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/366))
* **modules:** require TF v1.3+ ([#361](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/361))
* **TPG>=6.11:** add deletion protection variable to google_workflows_workflow ([#370](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/370))

### Features

* Add output variable env_vars ([#375](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/375)) ([ab9ed8c](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/ab9ed8c95fcb8db9517c1fc22aa52de7371bdfe8))
* add storage_billing_model and default_partition_expiration_ms ([#367](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/367)) ([53646de](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/53646dedc8167c17b9b609d2ed2d5ef37668f7bb))


### Bug Fixes

* **deps:** Update Terraform provider constraints ([#357](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/357)) ([c285f34](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/c285f3478a1cd65af1b0812515c2bb3484e9fa3b))
* **deps:** Update Terraform terraform-google-modules/project-factory/google to v18 ([#366](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/366)) ([d7723c4](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/d7723c495d6bf735e883543a2e83703877107368))
* **modules:** require TF v1.3+ ([#361](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/361)) ([9f9581b](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/9f9581b1fb066f938d2af611d6ece1fa162381fe))
* **TPG>=6.11:** add deletion protection variable to google_workflows_workflow ([#370](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/370)) ([7233527](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/72335270b153d959f0c3f46932f2970aaf5acdcc))

## [9.0.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v8.1.0...v9.0.0) (2024-10-16)


### ⚠ BREAKING CHANGES

* **deps:** Update Terraform terraform-google-modules/project-factory/google to v17 ([#358](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/358))
* **TPG>=5.39:** add resource_tags ([#354](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/354))

### Features

* **deps:** Update Terraform Google Provider to v6 (major) ([#347](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/347)) ([0fe8ab6](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/0fe8ab60d7291a2260cd460d55cdcca7fc815a0d))
* **TPG>=5.39:** add resource_tags ([#354](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/354)) ([c07d42e](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/c07d42e110b4012d2410acfbe6ceb6f4ac5ec2a4))


### Bug Fixes

* **deps:** Update Terraform terraform-google-modules/project-factory/google to v17 ([#358](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/358)) ([23446d6](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/23446d629021ecbae7a6c2a55c42db07d65c386f))

## [8.1.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v8.0.0...v8.1.0) (2024-08-20)


### Features

* use Gemini for generation ([#345](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/345)) ([03cdb71](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/03cdb71373d967c00da8f08e86c529387c1f394b))


### Bug Fixes

* **deps:** Update dependency google-cloud-dataform to v0.5.10 ([#334](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/334)) ([7a2ec7e](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/7a2ec7e184f3ba349ceec2eca668fc977f1402e4))

## [8.0.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v7.0.0...v8.0.0) (2024-07-29)


### ⚠ BREAKING CHANGES

* moved require_partition_filter to the top ([#335](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/335))
* add support to max_staleness field ([#278](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/278))

### Features

* add support to max_staleness field ([#278](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/278)) ([4c51616](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/4c51616f65a5994886917b1f09d4ba9d336f593b))
* adding extension notebooks ([#303](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/303)) ([b2816c4](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/b2816c469765c4c301c5227dd63cb3792c1c4247))
* allow fine-grained deletion protection config at the table-level ([#287](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/287)) ([7157c32](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/7157c323b664d910ddef26d87c0efa5f7209b174))
* data_warehouse Add GenAI capabilities  ([#272](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/272)) ([f88f4b5](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/f88f4b53ea5ed8416ed01e7285fa6018ddb8bd0b))
* expanded integration testing ([#288](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/288)) ([9dcdd07](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/9dcdd07f1e2a2b1cd4011fdf039fadca01bc32f0))
* Parameterize location and improve error messaging ([#289](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/289)) ([438b341](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/438b34134630cbbd4843f8a737c8784a1b83cb12))


### Bug Fixes

* adding regional constraints and simplifying workflow execution ([#284](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/284)) ([6146404](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/61464046e3e14b62cbb902617077fd2958167dbe))
* adding workaround for cloud workflows issue ([#310](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/310)) ([6878eb6](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/6878eb6cc830544edd7f0345cd644f3929f46681))
* Addressing permission conflicts ([#298](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/298)) ([dc3cb5e](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/dc3cb5e6feb71d28ab22df7c85c0813eae98eae2))
* adds a null check for expiration time ([#268](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/268)) ([b7efc4d](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/b7efc4d41ee5cc0ad4b6558dccc1b4696929525f))
* **deps:** Permissive Terraform terraform-google-modules/project-factory/google 14.4 ([#312](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/312)) ([be08779](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/be0877979127e19564288dc42884d6e0b1d9bbb7))
* **deps:** Update dependency google-cloud-dataform to v0.5.9 ([#308](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/308)) ([00ea7a4](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/00ea7a4d7dc844a09515b41e8cc2ee725211071d))
* **deps:** Update Terraform random to v3.6.1 ([#321](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/321)) ([3b5f265](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/3b5f265e3b36944b4c70d67508c08b2fa00072c6))
* **deps:** Update Terraform random to v3.6.2 ([#327](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/327)) ([369acc0](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/369acc0031880501b2c3d4e8cd1a072592a8c58a))
* **deps:** Update Terraform terraform-google-modules/project-factory/google to 14.4 ([#277](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/277)) ([85b9d22](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/85b9d2256c7bdfb44870b725a7c7c2a96f3297a9))
* moved require_partition_filter to the top ([#335](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/335)) ([90f931f](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/90f931f5ce827378108e42615938ff5d8e3f9b3f))
* update workflow.tftpl ([#266](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/266)) ([405972a](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/405972a27da0c0165b93f83162e4a595ec289263))

## [7.0.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v6.1.1...v7.0.0) (2023-10-10)


### ⚠ BREAKING CHANGES

* data_warehosue migrating to TheLook Ecommerce dataset ([#257](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/257))

### Features

* data_warehosue migrating to TheLook Ecommerce dataset ([#257](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/257)) ([e97adfb](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/e97adfb1984592a6f9e4eea8f8bdc3d2969e3d2d))
* data_warehouse add labels to objects ([#253](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/253)) ([70962af](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/70962afc68366e8ef1214b9ad747d3d15fa7f313))


### Bug Fixes

* data_warehouse add bigquery data policy api ([#254](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/254)) ([f2aa4f3](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/f2aa4f392e94603ca831c40c6c08dc3fbdae8af4))
* data_warehouse api identity dependency for p/s ([#252](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/252)) ([d2c1256](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/d2c125676f176c8fa33eb9dad12b7ed992dee6ac))
* **deps:** update terraform terraform-google-modules/project-factory/google to 14.3 ([#245](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/245)) ([cf6869c](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/cf6869c8f37999f4b765b7b9ac501c73a5ca3e36))
* update architecture diagrams, fix integration test ([#241](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/241)) ([bc5abf8](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/bc5abf8cb55bfc2c9939a1be6d6adfa7212e3a17))
* update workflow.tftpl bc subworkflow creates bq not biglake tables ([#246](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/246)) ([fc7d4ae](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/fc7d4ae15376a22a5f37c140fc4b1c1c4ad3aa52))
* upgrade hashicorp/google to 5.0 ([#259](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/259)) ([096ca4e](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/096ca4ee651152d040f8c555832488991773ddb8))
* upgraded versions.tf to include minor bumps from tpg v5 ([#261](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/261)) ([7fd5bcb](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/7fd5bcbb4eca4d71a0d1c9b7fb7f4d19ae21ddbf))

## [6.1.1](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v6.1.0...v6.1.1) (2023-07-20)


### Bug Fixes

* data_warehouse DTS SA, reorganization, fix workflow order ([88fe3ef](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/88fe3efe439af72121f9707639271c68d19e9041))

## [6.1.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v6.0.0...v6.1.0) (2023-06-22)


### Features

* adds metadata generation for the blueprint ([#220](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/220)) ([38b21b2](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/38b21b24fe69475e9855cc02a4209dc46ab9cfc9))
* data_warehouse enables public access prevention on buckets ([d33fddc](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/d33fddcab6dbf1702ebd61c8f1bb95cca4aa72e6))
* data_warehouse remove Cloud Function and replace with Workflows ([4fe1504](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/4fe1504b542281cb394a5014a980db058a01d1a6))


### Bug Fixes

* data_warehouse move workflows to file, add workflows identity ([b11e5f3](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/b11e5f32101e030d2cd3545db4d718cd1f98d3c0))
* data_warehouse update neos toc url ([75cce16](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/75cce16058770358e8a400512343e7e1dd142a97))
* **deps:** update data_warehouse dependency google-cloud-bigquery to v3.11.0 ([f270329](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/f2703293f3c746bf6336d6ebc3c2831bf4900b5e))
* **deps:** update data_warehouse dependency google-cloud-storage to v2.9.0 ([331145a](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/331145ab444c2b7fb7f65d46ad4543f537553a8a))
* **deps:** update data_warehouse terraform terraform-google-modules/project-factory/google to 14.2 ([6660e59](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/6660e59d8ab73b1ada846845045c881e1bd938e4))
* update dw neos tutorial link ([#215](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/215)) ([645e382](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/645e382bfe830c3111f5fa6cbe7bae8f87e691f4))

## [6.0.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.4.3...v6.0.0) (2023-04-13)


### ⚠ BREAKING CHANGES

* Increased minimum Google Provider version to 4.42 for root module ([#176](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/176)) and 4.44 for authorization sub-module ([#180](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/180))
* add max_time_travel_hours attribute ([#176](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/176))
* Add BQ authorized routine (function) in authorization sub-module ([#180](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/180))

### Features

* Add BigQuery data warehouse example ([#179](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/179)) ([ad3c347](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/ad3c3472b644fe79c37ae1416b28faf5e0cbe271))
* Add BQ authorized routine (function) in authorization sub-module ([#180](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/180)) ([d4f61d3](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/d4f61d3ee2427d8d42cab767c0326074c56d2c17))
* add max_time_travel_hours attribute ([#176](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/176)) ([706e540](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/706e540abfb727d75b51ef493af7cf49cc3081cf))
* add optional table_name attr ([#196](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/196)) ([03f01ed](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/03f01ed940244e1dff52f49df04ca7f46e30e83d))
* added optional description parameter ([#213](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/213)) ([59a73e5](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/59a73e5f474a0f9e59fdb37806bf9a18440987e5))


### Bug Fixes

* **deps:** update dependency google-cloud-storage to v2.8.0 ([#211](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/211)) ([a41234c](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/a41234c2f38524d37bea0919263df9eb204701ea))
* **deps:** update terraform terraform-google-modules/project-factory/google to v14 ([#186](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/186)) ([88d5fa4](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/88d5fa4a9fd8696566ef544a49e927e2a4c29a2e))
* Eventarc post deploy process ([#200](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/200)) ([ef34309](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/ef343096883bf6daaaea016ae561f089fab4539c))
* Fix sql and eventarc trigger ([#193](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/193)) ([3f77838](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/3f77838646470b6f42d9f4f47278e5f378143068))
* looker URL tableId ([#201](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/201)) ([6fd3339](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/6fd3339311a46cfbd98651ec5237f73b41a8d15f))
* pubsub sa grant ([#204](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/204)) ([9e795e4](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/9e795e42f78b757e0a92100d368e6bd297a97418))
* update neos link, remove solution guide url ([b64874a](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/b64874a31ca8078e735785669ae6e26f62100467))

## [5.4.3](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.4.2...v5.4.3) (2022-12-29)


### Bug Fixes

* fixes lint issues and generates metadata ([#171](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/171)) ([f278ff8](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/f278ff83df9aa7ac52f1eb9ed8ac571c314a5509))

## [5.4.2](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.4.1...v5.4.2) (2022-10-28)


### Bug Fixes

* Workaround issue causing permanent diff in access list ([#157](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/157)) ([cfa0c8c](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/cfa0c8cc37bf7a418b185fc128edaf7ce27def14))

## [5.4.1](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.4.0...v5.4.1) (2022-06-03)


### Bug Fixes

* Add project id to the resource configuration ([#149](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/149)) ([0aada16](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/0aada16a16b41180ecef95a8a7345332f2155d03))

## [5.4.0](https://github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.3.0...v5.4.0) (2022-03-18)


### Features

* Add submodule for creating scheduled queries ([#140](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/140)) ([b961094](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/b961094f000e22a4ebf1f67324175fdf36ede720))
* add support for authorized datasets in authorization submodule ([#142](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/142)) ([b93ba86](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/b93ba867eebea52a0b7ec0fa80c336b398eff4f4))
* Add support for materialized_views ([#139](https://github.com/terraform-google-modules/terraform-google-bigquery/issues/139)) ([e663c25](https://github.com/terraform-google-modules/terraform-google-bigquery/commit/e663c2513016ed85024bc546673c74624ea83205))

## [5.3.0](https://www.github.com/terraform-google-modules/terraform-google-bigquery/compare/v5.2.0...v5.3.0) (2021-12-23)


### Features

* update TPG version constraints to allow 4.0 ([#133](https://www.github.com/terraform-google-modules/terraform-google-bigquery/issues/133)) ([3795b11](https://www.github.com/terraform-google-modules/terraform-google-bigquery/commit/3795b11a59f87dc013dc35ffcaf8edc9d9059830))

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
