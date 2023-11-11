const express = require("express");
const router = express.Router();

const {
  createFaculty,
  getFaculty,
  getFacultyByfn,
} = require("../controllers/facultyControllers");

router.post("/", createFaculty);
router.get("/", getFaculty);
router.get("/:fn", getFacultyByfn);

module.exports = router;
