# Makefile

# Variables
CHART_PATH := ./charts/elasticsearch/Chart.yaml
VERSION_SCRIPT := ./get_version.sh
INCREMENT_SCRIPT := ./increment_version.sh

# Default target
all: increment

# Target to get the version number
version:
    @echo "Getting version number..."
    @version=$$($(VERSION_SCRIPT) $(CHART_PATH)); \
    echo "Version: $$version"

# Target to increment the version
increment:
    @echo "Incrementing version..."
    @version=$$($(VERSION_SCRIPT) $(CHART_PATH)); \
    new_version=$$($(INCREMENT_SCRIPT) $$version patch); \
    echo "New version: $$new_version"

# Target to validate the increment argument
validate:
    @if [ -z "$(INCREMENT)" ]; then \
        INCREMENT=patch; \
    fi

# Target to increment the version with the specified type
increment_type: validate
    @echo "Incrementing version..."
    @version=$$($(VERSION_SCRIPT) $(CHART_PATH)); \
    new_version=$$($(INCREMENT_SCRIPT) $$version $(INCREMENT)); \
    echo "New version: $$new_version"
