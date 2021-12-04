import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

class Part1 {
    public static void main(String[] args) {
        List<String> lines;

        try {
            lines = Files.readAllLines(Path.of("./input"));
        } catch (Exception e) {
            System.out.println("Error reading file");
            return;
        }

        int[] accumulators = new int[lines.get(0).length()];

        for (String line : lines) {
            for (int i = 0; i < line.length(); i++) {
                char c = line.charAt(i);
                if (c == '0') {
                    accumulators[i] -= 1;
                } else if (c == '1') {
                    accumulators[i] += 1;
                } else {
                    System.out.println("Invalid character: " + c);
                    return;
                }
            }
        }

        int gammaRate = 0;
        int deltaRate = 0;

        for (int i = 0; i < accumulators.length; i++) {
            if (accumulators[i] < 0) {
                deltaRate += 1 << (accumulators.length - i - 1);
            } else if (accumulators[i] > 0) {
                gammaRate += 1 << (accumulators.length - i - 1);
            } else {
                System.out.println("Invalid accumulator final value: " + accumulators[i]);
                return;
            }
        }

        System.out.println("Gamma rate: " + gammaRate);
        System.out.println("Delta rate: " + deltaRate);
        System.out.println("Epsilon rate: " + (gammaRate * deltaRate));
        return;
    }
}
