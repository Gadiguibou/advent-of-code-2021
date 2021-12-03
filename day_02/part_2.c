#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum
{
    Forward,
    Up,
    Down
} OperationType;

typedef struct
{
    OperationType type;
    long int value;
} Operation;

Operation
parse_line(char *line);

int main()
{
    FILE *input = fopen("./input", "r");
    char buffer[100] = {0};
    long int horizontal_position = 0;
    long int depth = 0;
    long int aim = 0;

    while (fgets(buffer, sizeof(buffer), input) != NULL)
    {
        Operation op = parse_line(buffer);
        switch (op.type)
        {
        case Forward:
            horizontal_position += op.value;
            depth += op.value * aim;
            break;
        case Up:
            aim -= op.value;
            break;
        case Down:
            aim += op.value;
            break;
        }
    }

    if (!feof(input) || ferror(input))
    {
        fprintf(stderr, "Error reading file\n");
        return EXIT_FAILURE;
    }

    fclose(input);

    printf("%ld\n", horizontal_position * depth);

    return EXIT_SUCCESS;
}

Operation parse_line(char *line)
{
    Operation op;
    char *operation_type = strtok(line, " ");
    if (strcmp(operation_type, "forward") == 0)
    {
        op.type = Forward;
    }
    else if (strcmp(operation_type, "up") == 0)
    {
        op.type = Up;
    }
    else if (strcmp(operation_type, "down") == 0)
    {
        op.type = Down;
    }
    else
    {
        fprintf(stderr, "Unknown operation type: %s\n", operation_type);
        exit(EXIT_FAILURE);
    }

    char *value = strtok(NULL, " ");
    op.value = atol(value);

    return op;
}
