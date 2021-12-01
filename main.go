package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/gin-gonic/gin"
)

func Hello(ctx *gin.Context) {
	name := ctx.Param("name")
	ctx.JSON(200, gin.H{"message": fmt.Sprintf("Hello %s!", name)})
}

func Engine() *gin.Engine {
	engine := gin.Default()
	engine.GET("/hello/:name", Hello)
	return engine
}

func Start() (*http.Server, error) {
	engine := Engine()
	server := &http.Server{Addr: "0.0.0.0:8080", Handler: engine}
	go func() {
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			fmt.Printf("ERROR %v\n", err)
		}
	}()
	return server, nil
}

func main() {
	// start server
	server, err := Start()
	if err != nil {
		fmt.Printf("Error starting server: %v", err)
		os.Exit(1)
	}
	// trap signals to shutdown server
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	if err := server.Shutdown(context.Background()); err != nil {
		log.Fatalf("Error shuting down the server: %v", err)
	}
}
