
# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

### Changed

- [Spartan-Chart](https://github.com/c0x12c/infra-helm/tree/master/charts/spartan) Added support for specifying HPA metrics using `autoscaling.metrics`. The use of `autoscaling.targetCPUUtilizationPercentage` and `autoscaling.targetMemoryUtilizationPercentage` is now deprecated

## [1.0.6] - 2024-01-18

Here we would have the update steps for 1.0.6 for people to follow.

### Added

### Changed

- [Spartan-Chart](https://github.com/c0x12c/infra-helm/tree/master/charts/spartan) Remove DD_APM_ENABLED in default Pod's environment variable
- [Spartan-Chart](https://github.com/c0x12c/infra-helm/tree/master/charts/spartan) Remove DD_PROFILING_ENABLED in default Pod's environment variable

### Fixed
