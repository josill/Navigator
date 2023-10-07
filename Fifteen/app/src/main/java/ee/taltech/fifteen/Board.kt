package ee.taltech.fifteen

class Board {
    private var numbers = (1..16).toList();

    fun createPuzzle(): List<Int> {
        var shuffledNumbers = numbers.shuffled();
        var inversionCount = 0;

        for (i in 0 until 16) {
            for (n in i until shuffledNumbers.size) {
                if (shuffledNumbers[i] != 16 && shuffledNumbers[i] > shuffledNumbers[n]) inversionCount++;
            }
        }

        if (inversionCount % 2 != 0) {
            return createPuzzle();
        }

        return shuffledNumbers;
    }
}