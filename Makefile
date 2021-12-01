BUILD_DIR = build

clean: # Clean generated files
	@rm -rf $(BUILD_DIR)

.PHONY: build
build: # Build project
	@mkdir -p $(BUILD_DIR)
	@go build -o $(BUILD_DIR) ./...

run: clean build # Run server
	@build/go-rest-api

integration: clean build # Run integration tests
	@build/go-rest-api &
	@venom run *.yml
	@killall go-rest-api
