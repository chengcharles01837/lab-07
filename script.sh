
#!/usr/bin/env bash

for n in 1 2 3 4; do
    input_dir="Testcase${n}"
    output_dir="Testcase${n}Diff"

    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        [ -f "$file2" ] || continue

        filename="${file1##*/}"
        basename="${filename%.1.txt}"

        if ! cmp -s "$file1" "$file2"; then
            mkdir -p "$output_dir"
            diff -u "$file1" "$file2" > "$output_dir/${basename}Diff.txt"
        fi
    done
done
