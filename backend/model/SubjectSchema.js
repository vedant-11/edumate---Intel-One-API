const mongoose = require("mongoose");

const subjectSchema = mongoose.Schema({
  _id: {
    type: String,
    required: true,
    default: Math.random().toString(36).substring(7),
  },
  subjectName: {
    type: String,
    required: true,
  },
  student: {
    type: String,
    required: true,
  },
  faculty: {
    type: String,
    required: true,
  },
  classHappened: {
    type: Array,
    default: [0],
  },
  present: {
    type: Array,
  },
  Marks: {
    type: Array,
  },
});

module.exports = mongoose.model("Subject", subjectSchema);
