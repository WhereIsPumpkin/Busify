import { Schema, model }  from "mongoose"

const busTicketSchema = new Schema(
  {
    cardName: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    duration: {
      type: String,
      required: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  { timestamps: true }
)

const BusTicket = model('BusTicket', busTicketSchema);

export default BusTicket