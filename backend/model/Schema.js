const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const student = new Schema({
  _id: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  semester: {
    type: Number,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  phone: {
    type: Number,
    required: true,
  },
  section: String,
  reg: {
    type: String,
    required: true,
  },
  points: {
    type: Number,
    default: 0,
  },
  device: {
    type: String,
    required: true,
  },
});

module.exports = mongoose.model("Student", student);
