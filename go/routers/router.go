package routers

import (
	"net/http"
	//"log"

	ctrs "my-blog-by-go/controllers"

	"github.com/gin-gonic/gin"
	//"my-blog-by-go/models"
)

// LoadRouters 初始化router
func LoadRouters(router *gin.Engine) {
	loadRouters(router)
}

func loadRouters(router *gin.Engine) {

	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"Status": 0,
			"data":   "Hello World!",
		})
	})

	router.POST("/upload", ctrs.UpLoadFile)
	//	router.GET("/remove", ctrs.RemoveFile)

	router.GET("/get-post/:postid", ctrs.GetHtmlStr)

	router.GET("/get-labels", ctrs.GetLabels)
	router.GET("/get-posts", ctrs.GetPosts)
	router.GET("/get-categories", ctrs.GetCategoies)
	router.GET("/get-posts-by-label/:labelid", ctrs.GetPostByLabelId)
	router.GET("/get-posts-by-category/:categoryid", ctrs.GetPostByCategoryId)
}
