import express from "express"
import connectToMongoDB from "./database/mongo.js"
import dotenv from "dotenv"
import bodyParser from "body-parser"
import userRoutes from "./routes/userRoutes.js"
import bookmarkRoutes from "./routes/bookmarkRoutes.js"

dotenv.config()
connectToMongoDB()

const app = express()

app.use(bodyParser.json())
app.use(express.json())

app.use("/api/user", userRoutes)

app.use("/api/bookmark", bookmarkRoutes)

connectToMongoDB().then(() => {
  app.listen(3000, () => {
    console.log("Server is listening on port 3000")
  })
})
