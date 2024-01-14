import express from "express"

const app = express()

app.get("/", (req,res) => {
    return res.status(200).json({ message: "app works!" })
})

app.listen(3000);