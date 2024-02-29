import express from "express"
import connectToMongoDB from "./database/mongo.js"
import dotenv from "dotenv"
import bodyParser from "body-parser"
import userRoutes from "./routes/userRoutes.js"
import bookmarkRoutes from "./routes/bookmarkRoutes.js"
import cardRoutes from "./routes/cardRoutes.js"
import balanceRoutes from "./routes/balanceRoutes.js"
import ticketRoutes from "./routes/ticketRoutes.js"

dotenv.config()
connectToMongoDB()

const app = express()

app.use(bodyParser.json())
app.use(express.json())

app.use("/api/user", userRoutes)

app.use("/api/bookmark", bookmarkRoutes)

app.use("/api/card", cardRoutes)

app.use("/api/balance", balanceRoutes)

app.use("/api/ticket", ticketRoutes)

connectToMongoDB().then(() => {
  app.listen(3000, () => {
    console.log("Server is listening on port 3000")
  })
})
