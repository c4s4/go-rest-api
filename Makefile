BUILD_DIR = build

.DEFAULT_GOAL :=
default: test integ

clean: # Clean generated files
	@rm -rf $(BUILD_DIR)

.PHONY: build
build: # Build project
	@mkdir -p $(BUILD_DIR)
	@go build -o $(BUILD_DIR) ./...

run: clean build # Run server
	@build/go-rest-api

test: # Run unit tests
	@go test -cover ./...

integ: clean build # Run integration tests
	@build/go-rest-api & \
		PID=$$!; \
		venom run *.yml; \
		kill $$PID
