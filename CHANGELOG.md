# Changelog

## [3.0.1](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v3.0.0...v3.0.1) (2023-11-02)


### Bug Fixes

* tf error when create_public_nlb is false ([#21](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/21)) ([5568923](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/5568923c88de59dbbb2d71e5a8a9bda214651137))

## [3.0.0](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v2.0.2...v3.0.0) (2023-08-21)


### ⚠ BREAKING CHANGES

* switch to EKS managed node groups by default ([#17](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/17))

### Features

* rely on `aws_eks_cluster` resource `version` default ([#20](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/20)) ([65dd9ec](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/65dd9ec192606ff03c11bd6f79f91253250e8987))
* switch to EKS managed node groups by default ([#17](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/17)) ([1f81e38](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/1f81e38397fce3957deedbc0dfe152737537393a))


### Bug Fixes

* autoscaling groups to NLBs attachment ([#19](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/19)) ([2c02776](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/2c0277614adc9407f9e9cc28f9b53964183f18e7))

## [2.0.2](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v2.0.1...v2.0.2) (2023-07-11)


### Documentation

* fix a few typos ([#15](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/15)) ([2dac66f](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/2dac66f20633fe89424d9e5604deaadc90540a1b))

## [2.0.1](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v2.0.0...v2.0.1) (2023-05-26)


### Bug Fixes

* wrong target group attached to private load balancer on port 80 ([#12](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/12)) ([81cbaee](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/81cbaee16160c027f72cae76788776797bc19b14))

## [2.0.0](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v1.0.0...v2.0.0) (2023-04-25)


### ⚠ BREAKING CHANGES

* remove untested cluster-autoscaler support ([#9](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/9))

### Features

* remove untested cluster-autoscaler support ([#9](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/9)) ([3565a7b](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/3565a7b919284487c64899bc687fd58dba003f98))

## [1.0.0](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v1.0.0-alpha.2...v1.0.0) (2023-03-24)


### Documentation

* correct module title and add PR template ([#6](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/6)) ([13eff88](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/13eff8865dd720be595c41afed6f88aad19f874a))

## [1.0.0-alpha.2](https://github.com/camptocamp/devops-stack-module-cluster-eks/compare/v1.0.0...v1.0.0-alpha.2) (2023-03-10)


### Features

* initial commit (migration from the main repo) ([b6b0a3a](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/b6b0a3aab02dfe2ea07b505d3f50dcad877f21e4))
* upgrade modules and Terraform providers ([#3](https://github.com/camptocamp/devops-stack-module-cluster-eks/issues/3)) ([200a6c3](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/200a6c32da9de6e627d13e82f3a3c2897ef17d55))

## 1.0.0-alpha.1 (2022-12-13)


### Features

* initial commit (migration from the main repo) ([b6b0a3a](https://github.com/camptocamp/devops-stack-module-cluster-eks/commit/b6b0a3aab02dfe2ea07b505d3f50dcad877f21e4))
