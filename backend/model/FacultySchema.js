const mongoose = require("mongoose");
const Schema = mongoose.Schema({
  _id: {
    type: String,
    required: true,
  },
  facultyName: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },

  fn: {
    type: String,
    required: true,
  },
  subjectName: {
    type: String,
    required: true,
  },
  section: {
    type: String,
    required: true,
  },
});

module.exports = mongoose.model("Faculty", Schema);
