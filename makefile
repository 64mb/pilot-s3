THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: \
dev-linux \
test

dev-linux:
	flutter run -d linux --dart-define=DEBUG=true

lint-fix:
	dart fix --apply

lint:
	dart analyze

test:
	flutter test