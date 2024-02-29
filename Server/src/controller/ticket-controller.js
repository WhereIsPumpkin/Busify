import QRCode from "qrcode"
import dotenv from "dotenv"
import BusTicket from "../models/BusTicket.js"
import User from "../models/User.js"
import { ticketReceiptTemplate } from "../utils/templates/ticketReceiptTemplate.js"
import transporter from "../utils/configs/emailTransporter.js"
import { validTicketTemplate } from "../utils/templates/validTicketTemplate.js"
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

    const durationMap = {
      duration_90min: "60 წუთი",
      duration_Daily: "1 დღე",
      duration_Weekly: "1 კვირა",
      duration_Monthly: "1 თვე",
      duration_Quarterly: "3 თვე",
      duration_Semiannual: "6 თვე",
      duration_Annual: "1 წელი",
    }

    const ticket = new BusTicket({
      cardName,
      price,
      duration: durationMap[duration],
      userId,
    })

    const formattedDuration = durationMap[duration]

    const savedTicket = await ticket.save()

    const qrCodeBuffer = await QRCode.toBuffer(
      `${process.env.BASE_URL}/api/ticket/verify/${savedTicket._id}`
    )

    let mailOptions = {
      from: "inetsupersocial@gmail.com",
      to: user.email,
      subject: "Your Bus Ticket",
      html: ticketReceiptTemplate(cardName, price, formattedDuration),
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

export const verifyTicket = async (req, res) => {
  const { ticketId } = req.params

  try {
    const ticket = await BusTicket.findById(ticketId).populate(
      "userId",
      "name lastName"
    )

    if (!ticket) {
      return res
        .status(404)
        .send("<html><body><h1>Ticket not found</h1></body></html>")
    }

    const purchaseDate = ticket.createdAt.toLocaleString()

    const htmlTemplate = validTicketTemplate(
      `${ticket.userId.name} ${ticket.userId.lastName}`,
      ticket.duration,
      ticket.price,
      purchaseDate
    )

    res.send(htmlTemplate)
  } catch (error) {
    console.error("Error in verifyTicket:", error)
    res
      .status(500)
      .json({ message: "Error verifying ticket", error: error.message })
  }
}
