import QRCode from "qrcode"
import dotenv from "dotenv"
import BusTicket from "../models/BusTicket.js"
import User from "../models/User.js"
import { ticketReceiptTemplate } from "../utils/templates/ticketReceiptTemplate.js"
import transporter from "../utils/configs/emailTransporter.js"
dotenv.config()

export const buyTicket = async (req, res) => {
  const userId = req.userData.id
  const { cardName, price, duration } = req.body

  try {
    const user = await User.findById(userId)
    if (!user) {
      return res.status(404).json({ message: "User not found" })
    }

    if (user.balance < price) {
      return res.status(400).json({
        message: "You do not have enough balance to purchase this ticket",
      })
    }

    const ticket = new BusTicket({
      cardName,
      price,
      duration,
      userId,
    })

    const savedTicket = await ticket.save()

    const qrCodeBuffer = await QRCode.toBuffer(
      `https://www.facebook.com/NRdental`
    )

    let mailOptions = {
      from: "inetsupersocial@gmail.com",
      to: user.email,
      subject: "Your Bus Ticket",
      html: ticketReceiptTemplate(cardName, price, duration),
      attachments: [
        {
          filename: "qrcode.png",
          content: qrCodeBuffer,
          cid: "qrcode",
        },
      ],
    }

    await transporter.sendMail(mailOptions)

    user.balance -= price
    await user.save()

    res.status(201).json({
      message: "Ticket purchased successfully",
      ticket: savedTicket,
      qrCodeURL: "QR code sent via email",
    })
  } catch (error) {
    console.error("Error in buyTicket:", error)
    res
      .status(500)
      .json({ message: "Error purchasing ticket", error: error.message })
  }
}
