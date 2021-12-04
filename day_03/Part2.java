import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

class Part1 {
    public static void main(String[] args) {
        List<String> lines;

        try {
            lines = Files.readAllLines(Path.of("./input"));
        } catch (Exception e) {
            System.out.println("Error reading file");
            return;
        }

        List<char[]> linesOfChars = lines.stream()
                .map(line -> line.toCharArray()).collect(Collectors.toList());

        List<char[]> oxygenRatingCandidates = linesOfChars;

        char[] oxygenRatingChars = filterOxygenCandidates(oxygenRatingCandidates);
        int oxygenRating = fromBinaryCharsToInt(oxygenRatingChars);

        char[] co2RatingChars = filterCo2Candidates(oxygenRatingCandidates);
        int co2Rating = fromBinaryCharsToInt(co2RatingChars);

        System.out.println("Oxygen rating: " + oxygenRating);
        System.out.println("CO2 rating: " + co2Rating);
        System.out.println("Life support rating: " + (oxygenRating * co2Rating));

        return;
    }

    private static char[] filterOxygenCandidates(List<char[]> initialCandidates) {
        List<char[]> candidates = initialCandidates;
        for (int i = 0; i < candidates.get(0).length; i++) {
            int accumulator = 0;

            for (char[] candidate : candidates) {
                if (candidate[i] == '0') {
                    accumulator--;
                } else if (candidate[i] == '1') {
                    accumulator++;
                } else {
                    System.out.println("Unknown character: " + candidate[i]);
                    return null;
                }
            }

            if (accumulator < 0) {
                List<char[]> newCandidates = new ArrayList<char[]>();

                for (char[] line : candidates) {
                    if (line[i] == '0') {
                        newCandidates.add(line);
                    }
                }
                candidates = newCandidates;
            } else if (accumulator >= 0) {
                List<char[]> newCandidates = new ArrayList<char[]>();

                for (char[] line : candidates) {
                    if (line[i] == '1') {
                        newCandidates.add(line);
                    }
                }
                candidates = newCandidates;
            }

            if (candidates.size() == 1) {
                return candidates.get(0);
            }
        }

        throw new RuntimeException("No solution found");
    }

    private static char[] filterCo2Candidates(List<char[]> initialCandidates) {
        List<char[]> candidates = initialCandidates;
        for (int i = 0; i < candidates.get(0).length; i++) {
            int accumulator = 0;

            for (char[] candidate : candidates) {
                if (candidate[i] == '0') {
                    accumulator--;
                } else if (candidate[i] == '1') {
                    accumulator++;
                } else {
                    System.out.println("Unknown character: " + candidate[i]);
                    return null;
                }
            }

            if (accumulator >= 0) {
                List<char[]> newCandidates = new ArrayList<char[]>();

                for (char[] line : candidates) {
                    if (line[i] == '0') {
                        newCandidates.add(line);
                    }
                }
                candidates = newCandidates;
            } else if (accumulator < 0) {
                List<char[]> newCandidates = new ArrayList<char[]>();

                for (char[] line : candidates) {
                    if (line[i] == '1') {
                        newCandidates.add(line);
                    }
                }
                candidates = newCandidates;
            }

            if (candidates.size() == 1) {
                return candidates.get(0);
            }
        }

        throw new RuntimeException("No solution found");
    }

    private static int fromBinaryCharsToInt(char[] chars) {
        int result = 0;
        for (int i = 0; i < chars.length; i++) {
            System.out.printf("%c", chars[i]);
            if (chars[i] == '1') {
                result += 1 << (chars.length - i - 1);
            }
        }
        return result;
    }
}
