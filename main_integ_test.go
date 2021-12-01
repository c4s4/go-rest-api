//go:build integration
// +build integration

package main

import (
	"context"
	"os/exec"
	"testing"
)

// TestIntegration runs integration tests:
// - starts server
// - calls Venom on command line
// - prints Venom output on error
// - shutdowns server
func TestIntegration(t *testing.T) {
	server, err := Start()
	if err != nil {
		t.Fatalf("starting server: %v", err)
	}
	out, err := exec.Command("venom", "run", "*.yml").Output()
	err2 := server.Shutdown(context.Background())
	if err != nil {
		t.Fatalf("running venom: %s", string(out))
	}
	if err2 != nil {
		t.Fatalf("shuting down server: %v", err)
	}
}
