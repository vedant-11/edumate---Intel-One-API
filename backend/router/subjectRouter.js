const express = require("express");
const router = express.Router();
const {
  createSubject,
  MarkPresent,
  getStudentWithSameSubAndFaculty,
} = require("../controllers/subjectController");

router.post("/", createSubject);
router.patch("/mark", MarkPresent);
router.get("/:subjectName/:faculty", getStudentWithSameSubAndFaculty);

module.exports = router;
