import scala.collection.mutable
import scala.io.Source
import scala.annotation.init

object Day24 {

  type Ops = Map[String, (String, String, String)]

  def simulate(ops: Ops, initialValues: Map[String, Int]): String = {
    val values = mutable.Map.from(initialValues)

    def getValue(s: String): Int = {
      values.get(s) match {
        case Some(value) => value
        case None =>
          val (op, a, b) = ops(s)
          values(s) = 0 // prevent infinite loops
          val aVal = getValue(a)
          val bVal = getValue(b)
          values(s) = 
            op match
              case "AND" => aVal & bVal
              case "OR" => aVal | bVal
              case "XOR" => aVal ^ bVal
          values(s)
      }
    }

    val zsReversed = ops.keys.filter(_.startsWith("z")).toList.sorted.reverse
    val zValues = zsReversed.map(getValue)
    zValues.mkString
  }

  def paddedBinaryStr(x: BigInt, n: Int): String = {
    val bits = x.toString(2)
    "0" * (n - bits.length()) + bits 
  }

  def toInputs(n: Int, pref: String, value: BigInt): Map[String, Int] = {
    paddedBinaryStr(value, n)
      .reverse
      .zipWithIndex
      .map{ (bit, i) =>
        val k = pref + "%02d".format(i)
        k -> (bit - '0')
      }
      .toMap
  }

  def numMatches(ops: Ops, x: BigInt, y: BigInt): (Int, String, String) = {
    val initialValues = toInputs(45, "x", x) ++ toInputs(45, "y", y)
    val actual = simulate(ops, initialValues)
    val expected = paddedBinaryStr(x + y, 46)
    var i = 0
    while (i < 46 && actual(45-i) == expected(45-i)) i += 1
    (i, actual, expected)
  }

  def main(args: Array[String]): Unit = {
    val inputLines = Source.fromFile("input/input24.txt").getLines().toList
    val (startInputs, (_ :: opInputs)) = inputLines.splitAt(inputLines.indexOf(""))
    val initialValues = startInputs.map { x => val Array(k, v) = x.split(": "); k -> v.toInt }.toMap
    val ops = opInputs.map { x => x.split(" ") match
      case Array(a, op, b, "->", c) => c -> (op, a, b)
    }.toMap

    val partOne = BigInt(simulate(ops, initialValues), 2)
    println(partOne)

    // Manually iterated filling in swaps using nextIncorrect
    val swaps = List(( "vss", "z14" ), ("hjf", "kdh"), ("kpp", "z31"), ("sgj", "z35"))
    val currOps = swaps.foldLeft(ops){ case (ops, (a, b)) => ops + (a -> ops(b)) + (b -> ops(a)) }
    val randNum = () => BigInt(util.Random.between(0L, 1L << 45))
    val (nextIncorrect, a, b) = (1 to 100).map { _ => numMatches(currOps, randNum(), randNum()) }.min
    if (nextIncorrect < 46) {
      println(nextIncorrect)
      println(a)
      println(b)
    } else {
      println(swaps.flatMap { (a,b) => List(a,b) }.sorted.mkString(","))
    }

  }
}