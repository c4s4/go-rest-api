package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func Hello(ctx *gin.Context) {
	name := ctx.Param("name")
	ctx.JSON(200, gin.H{"message": fmt.Sprintf("Hello %s!", name)})
}

func main() {
	engine := gin.Default()
	engine.GET("/hello/:name", Hello)
	engine.Run()
}
