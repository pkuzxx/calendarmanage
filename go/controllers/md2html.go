package controllers

import (
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"

	"my-blog-by-go/models"

	"github.com/gin-gonic/gin"
	"github.com/russross/blackfriday"
)

// GetHtmlStr 根据params获取id，读取本地md文件，然后返回字符串
func GetHtmlStr(c *gin.Context) {
	postid := c.Param("postid")
	if postid == "" {
		c.JSON(http.StatusNotFound, gin.H{
			"status": 1,
			"msg":    "postid 不能为空",
		})
	}
	postID, err := strconv.ParseInt(postid, 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusNotFound, gin.H{
			"status": 1,
			"msg":    "postid can't convert to int64, the error information: " + err.Error(),
		})
	}

	postInfo := models.GetPostByID(postID)
	file, openErr := ioutil.ReadFile("./posts/" + postInfo.FileName)
	if openErr != nil {
		log.Println(err)
		c.JSON(http.StatusNotFound, gin.H{
			"status": 1,
			"msg":    err.Error(),
		})
	}

	lines := strings.Split(string(file), "\n")
	body := strings.Join(lines[5:], "\n")
	body = string(blackfriday.Run([]byte(body)))
	c.JSON(http.StatusOK, gin.H{
		"status": 0,
		"data": gin.H{
			"id":         postInfo.Id,
			"title":      postInfo.Title,
			"createTime": postInfo.CreateTime,
			"textAmount": postInfo.TextAmount,
			"fileName":   postInfo.FileName,
			"content":    body,
		},
	})
}
