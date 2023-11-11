const mongoose = require("mongoose");
const { isNumberObject } = require("util/types");
const Schema = mongoose.Schema({
  _id: {
    type: String,
    required: true,
    default: Math.random().toString(36).substring(7),
  },
  facultyName: {
    type: String,
    required: true,
  },
  section: {
    type: String,
    required: true,
  },
  duration: {
    type: Number,
  },
  question: {
    type: Array,
  },
});

module.exports = mongoose.model("Test", Schema);
