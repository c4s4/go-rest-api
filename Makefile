BUILD_DIR = build
RED="\\033[91m"
GRE="\\033[92m"
END="\\033[0m"

.DEFAULT_GOAL :=
default: test integ integ-cover

clean: # Clean generated files
	@rm -rf $(BUILD_DIR)

.PHONY: build
build: # Build project
	@mkdir -p $(BUILD_DIR)
	@go build -o $(BUILD_DIR) ./...

run: clean build # Run server
	@build/go-rest-api

test: # Run unit tests
	@mkdir -p $(BUILD_DIR)
	@go test -coverprofile $(BUILD_DIR)/coverage-unit.out $(GOPACKAGE) || (echo "$(RED)ERROR$(END) unit tests failed"; exit 1)
	@go tool cover -html=$(BUILD_DIR)/coverage-unit.out -o $(BUILD_DIR)/coverage-unit.html
	@echo "Unit test coverage report in $$(pwd)/$(BUILD_DIR)/coverage-unit.html"
	@echo "$(GRE)OK$(END) unit tests passed"

integ: clean build # Run integration tests
	@build/go-rest-api & \
		PID=$$!; \
		venom run *.yml; \
		kill $$PID

integ-cover: # Run integration tests with coverage
	@mkdir -p $(BUILD_DIR)
	@go test -c -o $(BUILD_DIR)/go-rest-api-integ -covermode=set -coverpkg=./... -tags integration .
	@build/go-rest-api-integ -test.coverprofile=$(BUILD_DIR)/coverage-integ.out || (echo "$(RED)ERROR$(END) integration tests failed"; exit 1)
	@go tool cover -html=$(BUILD_DIR)/coverage-integ.out -o $(BUILD_DIR)/coverage-integ.html
	@echo "Integration tests coverage report in $$(pwd)/$(BUILD_DIR)/coverage-integ.html"
	@echo "$(GRE)OK$(END) integration tests success"
