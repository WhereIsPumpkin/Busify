import { Schema } from 'mongoose';

const cardSchema = new Schema({
  cardNumber: {
    type: Schema.Types.String,
    required: false,
  },
  cardName: {
    type: Schema.Types.String,
    required: false,
  },
  cardDate: {
    type: Schema.Types.String,
    required: false,
  },
  cardCVV: {
    type: Schema.Types.String,
    required: false,
  },
}, { _id: false });

export default cardSchema;
