.PHONY: help install setup build run test clean format analyze lint fastlane

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

##@ General

help: ## Display this help message
	@echo "$(BLUE)Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(BLUE)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Setup

install: ## Install Flutter dependencies
	@echo "$(BLUE)Installing Flutter dependencies...$(NC)"
	flutter pub get

setup: install ## Complete setup (dependencies + iOS pods)
	@echo "$(BLUE)Setting up iOS dependencies...$(NC)"
	cd ios && pod install

setup-android: install ## Setup Android dependencies
	@echo "$(BLUE)Android setup complete$(NC)"

setup-ios: install ## Setup iOS dependencies
	@echo "$(BLUE)Installing iOS pods...$(NC)"
	cd ios && pod install

##@ Build

build-dev: ## Build development APK/IPA
	@echo "$(BLUE)Building development app...$(NC)"
	flutter build apk --debug --flavor dev -t lib/main_dev.dart || \
	flutter build ios --debug --flavor dev -t lib/main_dev.dart --no-codesign

build-staging: ## Build staging APK/IPA
	@echo "$(BLUE)Building staging app...$(NC)"
	flutter build apk --release --flavor staging -t lib/main_staging.dart || \
	flutter build ios --release --flavor staging -t lib/main_staging.dart --no-codesign

build-prod: ## Build production APK/IPA
	@echo "$(BLUE)Building production app...$(NC)"
	flutter build apk --release --flavor prod -t lib/main_prod.dart || \
	flutter build ios --release --flavor prod -t lib/main_prod.dart --no-codesign

build-android-dev: ## Build Android development APK
	@echo "$(BLUE)Building Android development APK...$(NC)"
	flutter build apk --debug --flavor dev -t lib/main_dev.dart

build-android-staging: ## Build Android staging APK
	@echo "$(BLUE)Building Android staging APK...$(NC)"
	flutter build apk --release --flavor staging -t lib/main_staging.dart

build-android-prod: ## Build Android production APK
	@echo "$(BLUE)Building Android production APK...$(NC)"
	flutter build apk --release --flavor prod -t lib/main_prod.dart

build-android-bundle: ## Build Android App Bundle (for Play Store)
	@echo "$(BLUE)Building Android App Bundle...$(NC)"
	flutter build appbundle --release --flavor prod -t lib/main_prod.dart

build-ios-dev: ## Build iOS development (no codesign)
	@echo "$(BLUE)Building iOS development...$(NC)"
	flutter build ios --debug --flavor dev -t lib/main_dev.dart --no-codesign

build-ios-staging: ## Build iOS staging (no codesign)
	@echo "$(BLUE)Building iOS staging...$(NC)"
	flutter build ios --release --flavor staging -t lib/main_staging.dart --no-codesign

build-ios-prod: ## Build iOS production (no codesign)
	@echo "$(BLUE)Building iOS production...$(NC)"
	flutter build ios --release --flavor prod -t lib/main_prod.dart --no-codesign

##@ Run

run-dev: ## Run app in development mode
	@echo "$(BLUE)Running app in development mode...$(NC)"
	flutter run --flavor dev -t lib/main_dev.dart

run-staging: ## Run app in staging mode
	@echo "$(BLUE)Running app in staging mode...$(NC)"
	flutter run --flavor staging -t lib/main_staging.dart

run-prod: ## Run app in production mode
	@echo "$(BLUE)Running app in production mode...$(NC)"
	flutter run --flavor prod -t lib/main_prod.dart

run: run-dev ## Run app (default: dev)

##@ Test

test: ## Run all tests
	@echo "$(BLUE)Running all tests...$(NC)"
	flutter test

test-unit: ## Run unit tests only
	@echo "$(BLUE)Running unit tests...$(NC)"
	flutter test --exclude-tags=golden

test-golden: ## Run golden/snapshot tests
	@echo "$(BLUE)Running golden tests...$(NC)"
	flutter test --tags=golden

test-golden-update: ## Update golden test files
	@echo "$(BLUE)Updating golden test files...$(NC)"
	flutter test --tags=golden --update-goldens

test-coverage: ## Run tests with coverage
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	flutter test --coverage
	@echo "$(GREEN)Coverage report generated in coverage/lcov.info$(NC)"

##@ Code Quality

format: ## Format Dart code
	@echo "$(BLUE)Formatting code...$(NC)"
	dart format .

format-check: ## Check if code is formatted
	@echo "$(BLUE)Checking code formatting...$(NC)"
	dart format --set-exit-if-changed .

analyze: ## Analyze Dart code
	@echo "$(BLUE)Analyzing code...$(NC)"
	flutter analyze

lint: format-check analyze ## Run all linting checks

fix: ## Auto-fix linting issues
	@echo "$(BLUE)Fixing linting issues...$(NC)"
	dart fix --apply

##@ Fastlane

fastlane-ios-beta: ## Deploy iOS to TestFlight
	@echo "$(BLUE)Deploying iOS to TestFlight...$(NC)"
	cd ios && bundle exec fastlane beta

fastlane-ios-release: ## Deploy iOS to App Store
	@echo "$(BLUE)Deploying iOS to App Store...$(NC)"
	cd ios && bundle exec fastlane release

fastlane-ios-sync-certs: ## Sync iOS certificates
	@echo "$(BLUE)Syncing iOS certificates...$(NC)"
	cd ios && bundle exec fastlane sync_certs

fastlane-android-beta: ## Deploy Android to Internal Testing
	@echo "$(BLUE)Deploying Android to Internal Testing...$(NC)"
	cd android && bundle exec fastlane beta

fastlane-android-release: ## Deploy Android to Production
	@echo "$(BLUE)Deploying Android to Production...$(NC)"
	cd android && bundle exec fastlane release

##@ Clean

clean: ## Clean build files
	@echo "$(BLUE)Cleaning build files...$(NC)"
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/

clean-ios: ## Clean iOS build files
	@echo "$(BLUE)Cleaning iOS build files...$(NC)"
	cd ios && rm -rf Pods/ Podfile.lock .symlinks/ Flutter/ephemeral
	flutter clean

clean-android: ## Clean Android build files
	@echo "$(BLUE)Cleaning Android build files...$(NC)"
	cd android && ./gradlew clean
	flutter clean

clean-all: clean clean-ios clean-android ## Clean everything

##@ Utilities

doctor: ## Run Flutter doctor
	@echo "$(BLUE)Running Flutter doctor...$(NC)"
	flutter doctor -v

upgrade: ## Upgrade Flutter dependencies
	@echo "$(BLUE)Upgrading dependencies...$(NC)"
	flutter pub upgrade

outdated: ## Check for outdated dependencies
	@echo "$(BLUE)Checking for outdated dependencies...$(NC)"
	flutter pub outdated

deps: ## Show dependency tree
	@echo "$(BLUE)Dependency tree:$(NC)"
	flutter pub deps

version: ## Show Flutter and Dart versions
	@echo "$(BLUE)Flutter version:$(NC)"
	@flutter --version
	@echo "\n$(BLUE)Dart version:$(NC)"
	@dart --version

version-app: ## Show app version from pubspec.yaml
	@./scripts/version.sh get

version-bump-patch: ## Bump patch version (1.0.0 -> 1.0.1)
	@./scripts/version.sh bump patch

version-bump-minor: ## Bump minor version (1.0.0 -> 1.1.0)
	@./scripts/version.sh bump minor

version-bump-major: ## Bump major version (1.0.0 -> 2.0.0)
	@./scripts/version.sh bump major

version-bump-build: ## Bump build number (1.0.0+1 -> 1.0.0+2)
	@./scripts/version.sh bump build

version-set: ## Set version explicitly (usage: make version-set VERSION=1.2.3 BUILD=10)
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)Error: VERSION is required$(NC)"; \
		echo "Usage: make version-set VERSION=1.2.3 BUILD=10"; \
		exit 1; \
	fi
	@./scripts/version.sh set $(VERSION) $(BUILD)

##@ CI/CD

ci-analyze: format-check analyze ## Run CI analysis checks
	@echo "$(GREEN)CI analysis complete$(NC)"

ci-test: test ## Run CI tests
	@echo "$(GREEN)CI tests complete$(NC)"

ci-build-android: build-android-prod ## CI: Build Android production
	@echo "$(GREEN)CI Android build complete$(NC)"

ci-build-ios: build-ios-prod ## CI: Build iOS production
	@echo "$(GREEN)CI iOS build complete$(NC)"
